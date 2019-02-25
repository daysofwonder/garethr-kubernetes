
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_config_map_env_source).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        name: instance.name.respond_to?(:to_hash) ? instance.name.to_hash : instance.name,
      
      
    
      
      
        optional: instance.optional.respond_to?(:to_hash) ? instance.optional.to_hash : instance.optional,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_config_map_env_source #{name}")
    create_instance_of('config_map_env_source', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('config_map_env_source', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_config_map_env_source #{name}")
    destroy_instance_of('config_map_env_source', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('config_map_env_source')
  end

  def build_params
    params = {
    
      
        name: resource[:name],
      
    
      
        optional: resource[:optional],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
