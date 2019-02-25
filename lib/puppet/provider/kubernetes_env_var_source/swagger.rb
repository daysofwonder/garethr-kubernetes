
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_env_var_source).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        field_ref: instance.fieldRef.respond_to?(:to_hash) ? instance.fieldRef.to_hash : instance.fieldRef,
      
      
    
      
      
        resource_field_ref: instance.resourceFieldRef.respond_to?(:to_hash) ? instance.resourceFieldRef.to_hash : instance.resourceFieldRef,
      
      
    
      
      
        config_map_key_ref: instance.configMapKeyRef.respond_to?(:to_hash) ? instance.configMapKeyRef.to_hash : instance.configMapKeyRef,
      
      
    
      
      
        secret_key_ref: instance.secretKeyRef.respond_to?(:to_hash) ? instance.secretKeyRef.to_hash : instance.secretKeyRef,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_env_var_source #{name}")
    create_instance_of('env_var_source', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('env_var_source', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_env_var_source #{name}")
    destroy_instance_of('env_var_source', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('env_var_source')
  end

  def build_params
    params = {
    
      
        fieldRef: resource[:field_ref],
      
    
      
        resourceFieldRef: resource[:resource_field_ref],
      
    
      
        configMapKeyRef: resource[:config_map_key_ref],
      
    
      
        secretKeyRef: resource[:secret_key_ref],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
