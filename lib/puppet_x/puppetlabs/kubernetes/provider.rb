require 'puppet'
require 'puppet/util/network_device'

require_relative '../swagger/provider'
require_relative '../swagger/fixnumify'

module PuppetX
  module Puppetlabs
    module Kubernetes
      class Provider < PuppetX::Puppetlabs::Swagger::Provider
        PUPPET_K8S_ANNOTATIONS = 'com.daysofwonder.puppet.resource-name'.freeze.to_sym

        def self.inherited(subclass)
          subclass.confine feature: :kubeclient
          super
        end

        def self.config
          @config ||= begin
            Puppet.initialize_settings unless Puppet[:confdir]
            file = Puppet::Util::NetworkDevice.current ? Puppet::Util::NetworkDevice.current.kubeclient_config : File.join(Puppet[:confdir], 'kubernetes.conf')
            Puppet.debug("Checking for config file at #{file}")
            Kubeclient::Config.read(file)
          end
        end

        def self.add_headers(subject)
          subject.headers = subject.headers.merge(content_type: :json, accept: :json)
          subject
        end

        def self.base_client(endpoint = '', version = '')
          ::Kubeclient::Client.new(
            "#{config.context.api_endpoint}#{endpoint}",
            "#{config.context.api_version}#{version}",
            ssl_options: config.context.ssl_options,
            auth_options: config.context.auth_options,
          )
        end

        def self.v1_client
          base_client
        end

        def self.beta_client
          base_client('/apis/extensions', 'beta1')
        end

        def self.rbac_client
          base_client('/apis/rbac.authorization.k8s.io')
        end

        def self.policy_client
          base_client('/apis/policy', 'beta1')
        end

        def self.v1_app
          base_client('/apis/apps')
        end

        def self.call(method, *object)
          if v1_client.respond_to?(method)
            v1_client.send(method, *object)
          elsif v1_app.respond_to?(method)
            v1_app.send(method, *object)
          elsif policy_client.respond_to?(method)
            policy_client.send(method, *object)
          elsif beta_client.respond_to?(method)
            beta_client.send(method, *object)
          else
            rbac_client.send(method, *object)
          end
        end

        def self.list_instances_of(type)
          call("get_#{pluralize(type)}")
        end

        # this is a poor man pluralize, check ActiveSupport for a more general one
        def self.pluralize(noun)
          return noun.gsub(%r{y$}, 'ies') if noun.end_with?('y')
          return noun + 's' unless noun.end_with?('s')
          noun + 'es'
        end

        # build the puppet resource name from the k8s resource name
        def self.instance_name(instance)
          annotations = (instance.metadata.annotations || {}).to_hash
          # easy-peasy, we have it on hand
          return annotations[PUPPET_K8S_ANNOTATIONS] if annotations.include?(PUPPET_K8S_ANNOTATIONS)
          # not so easy, there's two possibilities, either try <namespace>::<name> or go
          # with <name> alone
          return [instance.metadata.namespace, instance.metadata.name].join('::') unless instance.metadata.namespace.nil? || instance.metadata.namespace == 'default'
          instance.metadata.name
        end

        def make_object(_type, name, params)
          params[:metadata] = {} unless params.key?(:metadata)
          p = params.swagger_symbolize_keys
          object = Kubeclient::Resource.new(p)
          # two possibilities,
          # 1. the puppet name is `${k8s_namespace}::${k8s_name}`
          # error if the md is not consistent
          # 2. the puppet name is just a name, we then trust the metadata
          # to be correct

          k8s_name = puppet_to_k8s_name(name)
          raise_on_metadata_discrepency(object.metadata, k8s_name)

          object.metadata.name ||= k8s_name[:name]
          if k8s_name.include?(:namespace)
            object.metadata.namespace ||= k8s_name[:namespace]
          else
            # we don't know the namespace yet, it can either be the one specified
            # or a no namespace resource
            object.metadata.namespace = namespace unless namespace.nil?
          end

          annotate_k8s_object(object, name)
          object
        end

        def raise_on_metadata_discrepency(metadata, fqdn)
          md = [metadata.namespace, metadata.name].compact
          puppet_name = [fqdn[:namespace], fqdn[:name]].compact
          raise 'Resource name (<namespace>::<name>) should match kubernetes metadata' if puppet_name.size == 2 && md.size == 2 && md != puppet_name
        end

        def create_instance_of(type, name, params)
          call("create_#{type}", make_object(type, name, params))
        end

        class ObjectSetter
          def initialize(obj)
            @object = obj
          end

          def set(attr, value)
            if @object.nil?
              @object = {}
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
                @object << {}
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
            ->(value) do
              obj.send("#{attr}=", value)
            end
          end
        end

        def ensure_value_at_path(object, path, value)
          path.each_with_index.reduce(ObjectSetter.new(object)) do |setter, (attr, index)|
            if index == (path.size - 1)
              setter.set(attr, value)
            else
              setter.get(attr)
            end
          end
        end

        def build_applicator(input)
          data = []
          input.each do |key, value|
            if value.respond_to? :each
              value.each do |inner_key, inner_value|
                if [Integer, String].include? inner_value.class
                  data << [[key, inner_key], inner_value]
                end
                if inner_value.class == Array
                  inner_value.each_with_index do |item, index|
                    item.each do |k, v|
                      data << [[key, inner_key, index, k], v]
                    end
                  end
                end
                next unless inner_value.class == Hash
                applicator = build_applicator(inner_value)
                applicator.each do |k, v|
                  data << [[key, inner_key, k].flatten, v]
                end
              end
            else
              data << [[key], value]
            end
          end
          data
        end

        def apply_applicator(_type, object, changes)
          changes.each do |path, value|
            ensure_value_at_path(object, path, value)
          end
          object
        end

        def flush_instance_of(type, name, object, params)
          applicator = build_applicator(params)
          updated = apply_applicator(type, object, applicator)

          # check that puppet name <namespace>::<name> matches
          # metadata if any
          if name.include?('::')
            puppet_name = puppet_to_k8s_name(name)
            raise_on_metadata_discrepency(object.metadata, puppet_name)
          end

          annotate_k8s_object(object, name)
          call("update_#{type}", updated)
        end

        # Keep puppet name in the k8s object so that we can later
        # find what puppet resource it was coming from
        def annotate_k8s_object(object, name)
          object.metadata.annotations ||= {}
          object.metadata.annotations[PUPPET_K8S_ANNOTATIONS] = name
        end

        # rubocop:disable Style/MethodMissing
        def self.method_missing(method_sym, *arguments, &block)
          call(method_sym, *arguments, &block)
        end
        # rubocop:enable Style/MethodMissing

        def destroy_instance_of(type, name)
          k8s_name = puppet_to_k8s_name(name)
          call("delete_#{type}", k8s_name[:name], namespace)
        end

        def call(method, *object)
          self.class.call(method, *object)
        end

        def puppet_to_k8s_name(puppet_name)
          (k8s_namespace, k8s_name) = puppet_name.split('::')
          return { name: k8s_namespace } if k8s_name.nil?
          { name: k8s_name, namespace: k8s_namespace }
        end

        # used by the swagger provider to match an instance coming from k8s
        # to an existing puppet resources
        # we try to be clever by looking directly with the puppet resource name
        # but also by the annotation, or a FQDN
        def self.find_puppet_resource(resources, prov)
          looking_for = [prov.name]
          k8s_md = prov.get(:metadata)
          if k8s_md != :absent
            annotations = (k8s_md[:annotations] || {}).to_hash
            looking_for << annotations[PUPPET_K8S_ANNOTATIONS] if annotations.include?(PUPPET_K8S_ANNOTATIONS)
            looking_for << [k8s_md[:namespace], k8s_md[:name]].join('::')
            looking_for << k8s_md[:name] # last resort
          end
          name = looking_for.compact.uniq.find { |n| resources.include?(n) }
          return resources[name] unless name.nil?
          nil
        end

        def namespace
          if metadata == :absent
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
            metadata[:namespace] || nil
          end
        end
      end
    end
  end
end
