require 'puppet'
require 'puppet/util/network_device'

require_relative '../swagger/provider'
require_relative '../swagger/fixnumify'

# With the Kubernetes proxy on OpenShift (or maybe a change in Kubernetes 1.2)
# the API requires that the accept headers be correctly set. At the moment this
# is not done nor exposed by the client library. So lets monkeypatch it to allow
# us to override the headers.
module Kubeclient
  class Client
    def headers=(value)
      @headers = value
    end
  end
end


module PuppetX
  module Puppetlabs
    module Kubernetes
      class Provider < PuppetX::Puppetlabs::Swagger::Provider

        def self.inherited(subclass)
          subclass.confine :feature => :kubeclient
          super
        end

        private
        def self.config
          @config ||= begin
            Puppet.initialize_settings unless Puppet[:confdir]
            file = Puppet::Util::NetworkDevice.current ? Puppet::Util::NetworkDevice.current.kubeclient_config : File.join(Puppet[:confdir], 'kubernetes.conf')
            Puppet.debug("Checking for config file at #{file}")
            Kubeclient::Config.read(file)
          end
        end

        def self.add_headers(subject)
          subject.headers = subject.headers.merge({:content_type => :json, :accept => :json})
          subject
        end

        def self.v1_client
          client = ::Kubeclient::Client.new(
            config.context.api_endpoint,
            config.context.api_version,
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
          add_headers(client)
        end

        def self.beta_client
          client = ::Kubeclient::Client.new(
            "#{config.context.api_endpoint}/apis/extensions",
            "#{config.context.api_version}beta1",
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
          add_headers(client)
        end

        def self.rbac_client
          client = ::Kubeclient::Client.new(
            "#{config.context.api_endpoint}/apis/rbac.authorization.k8s.io",
            "#{config.context.api_version}",
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
          add_headers(client)
        end

        def self.v1_app
          client = ::Kubeclient::Client.new(
            "#{config.context.api_endpoint}/apis/apps",
            config.context.api_version,
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
          add_headers(client)
        end

        def self.call(method, *object)
          if v1_client.respond_to?(method)
            v1_client.send(method, *object)
          elsif v1_app.respond_to?(method)
            v1_app.send(method, *object)
          elsif beta_client.respond_to?(method)
            beta_client.send(method, *object)
          else
            rbac_client.send(method, *object)
          end
        end

        def self.list_instances_of(type)
          call("get_#{type}s")
        end

        def make_object(type, name, params)
          klass = type.split('_').collect(&:capitalize).join
          params[:metadata] = {} unless params.key?(:metadata)
          p = params.swagger_symbolize_keys
          object = Object::const_get("Kubeclient::#{klass}").new(p)
          object.metadata.name = name
          object.metadata.namespace = namespace unless namespace.nil?
          object
        end

        def create_instance_of(type, name, params)
          call("create_#{type}", make_object(type, name, params))
        end

        class ObjectSetter
          def initialize(obj, klass)
            @object = obj
            @klass = klass
          end

          def set(attr, value)
            if @object.nil?
              @object = RecursiveOpenStruct.new(nil, recurse_over_arrays: true)
              @parent_setter.call(@object)
            end
            @parent_setter = create_parent_setter(@object, attr)
            @object = @object.send("#{attr}=", value)
            self
          end

          def get(attr)
            if attr.is_a?(Numeric)
              if @object.nil?
                @object = []
                @parent_setter.call(@object)
              end
              if @object.send(:at, attr).nil?
                @object << RecursiveOpenStruct.new(nil, recurse_over_arrays: true)
              end
              @parent_setter = create_parent_setter(@object, attr)
              @object = @object.send(:at, attr)
            else
              if @object.send(attr).nil?
                new_object = {}
                @object.send("#{attr}=", new_object)
              end
              @parent_setter = create_parent_setter(@object, attr)
              @object = @object.send(attr)
            end
            self
          end

          def create_parent_setter(obj, attr)
            lambda do |value|
              obj.send("#{attr}=", value)
            end
          end
        end


        def ensure_value_at_path(object, klass, path, value)
          path.each_with_index.inject(ObjectSetter.new(object, klass)) { |setter, (attr, index)|
            if index == (path.size - 1)
              setter.set(attr, value)
            else
              setter.get(attr)
            end
          }
        end

        def build_applicator(input)
          data = []
          input.each do |key,value|
            if value.respond_to? :each
              value.each do |inner_key,inner_value|
                if [Integer, String].include? inner_value.class
                  data << [[key,inner_key], inner_value]
                end
                if inner_value.class == Array
                  inner_value.each_with_index do |item,index|
                    item.each do |k,v|
                      data << [[key, inner_key, index, k], v]
                    end
                  end
                end
                if inner_value.class == Hash
                  applicator = build_applicator(inner_value)
                  applicator.each do |k,v|
                    data << [[key, inner_key, k].flatten, v]
                  end
                end
              end
            else
              data << [[key], value]
            end
          end
          data
        end

        def apply_applicator(type, object, changes)
          klass = type.split('_').collect(&:capitalize).join
          changes.each do |path, value|
            ensure_value_at_path(object, klass, path, value)
          end
          object
        end

        def flush_instance_of(type, name, object, params)
          applicator = build_applicator(params)
          updated = apply_applicator(type, object, applicator)
          call("update_#{type}", updated)
        end

        def self.method_missing(method_sym, *arguments, &block)
          call(method_sym, *arguments, &block)
        end

        def destroy_instance_of(type, name)
          call("delete_#{type}", name, namespace)
        end

        def call(method, *object)
          self.class.call(method, *object)
        end

        def namespace
          if self.metadata == :absent
            # This means the resource doesn't exist already
            if resource[:metadata]
              resource[:metadata]['namespace']
            else
              # for resources without metadata like namespaces
              # we don't need to set a namespace
              nil
            end
          else
            # here we're reading from the API so we don't need to
            # provide any default values
            self.metadata[:namespace] || nil
          end
        end
      end
    end
  end
end
