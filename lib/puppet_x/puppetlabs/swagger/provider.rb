require_relative 'prefetch_error'

module PuppetX
  module Puppetlabs
    module Swagger
      class Provider < Puppet::Provider
        def self.read_only(*methods)
          methods.each do |method|
            define_method("#{method}=") do |_v|
              raise "#{method} property is read-only once #{resource.type} created."
            end
          end
        end

        def self.instances
          list_instances.map { |instance|
            begin
              hash = instance_to_hash(instance)
              Puppet.debug("Ignoring #{name} due to invalid or incomplete response") unless hash
              new(hash) if hash
            end
          }.compact
        rescue Timeout::Error => e
          raise PuppetX::Puppetlabs::Swagger::PrefetchError.new(resource_type.name.to_s, e)
        rescue StandardError => e
          raise PuppetX::Puppetlabs::Swagger::PrefetchError.new(resource_type.name.to_s, e)
        end

        def self.prefetch(resources)
          instances.each do |prov|
            if resource = find_puppet_resource(resources, prov) # rubocop:disable Lint/AssignmentInCondition
              resource.provider = prov
            end
          end
        end

        def self.find_puppet_resource(resources, prov)
          resources[prov.name]
        end

        def self.hash_arrays(object)
          unless object.nil?
            object = object.map do |value|
              if value.respond_to?(:to_a)
                hash_arrays(value)
              elsif value.respond_to?(:to_hash)
                value.to_hash
              else
                value
              end
            end
          end
          object
        end

        def exists?
          Puppet.debug("Checking if #{resource.type}[#{name}] exists")
          @property_hash[:ensure] && @property_hash[:ensure] != :absent
        end

        def self.list_instance_of(_type)
          raise 'Needs implementation in your own provider'
        end

        def create_instance_of(_type, _name, _params)
          raise 'Needs implementation in your own provider'
        end

        def destroy_instance_of(_type, _name)
          raise 'Needs implementation in your own provider'
        end

        def flush_instance_of(_type)
          raise 'Needs implementation in your own provider'
        end
      end
    end
  end
end
