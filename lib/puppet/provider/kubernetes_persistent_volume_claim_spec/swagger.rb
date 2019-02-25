
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_persistent_volume_claim_spec).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        access_modes: hash_arrays(accessModes),
      
      
    
      
      
        selector: instance.selector.respond_to?(:to_hash) ? instance.selector.to_hash : instance.selector,
      
      
    
      
      
        resources: instance.resources.respond_to?(:to_hash) ? instance.resources.to_hash : instance.resources,
      
      
    
      
      
        volume_name: instance.volumeName.respond_to?(:to_hash) ? instance.volumeName.to_hash : instance.volumeName,
      
      
    
      
      
        storage_class_name: instance.storageClassName.respond_to?(:to_hash) ? instance.storageClassName.to_hash : instance.storageClassName,
      
      
    
      
      
        volume_mode: instance.volumeMode.respond_to?(:to_hash) ? instance.volumeMode.to_hash : instance.volumeMode,
      
      
    
      
      
        data_source: instance.dataSource.respond_to?(:to_hash) ? instance.dataSource.to_hash : instance.dataSource,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_persistent_volume_claim_spec #{name}")
    create_instance_of('persistent_volume_claim_spec', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('persistent_volume_claim_spec', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_persistent_volume_claim_spec #{name}")
    destroy_instance_of('persistent_volume_claim_spec', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('persistent_volume_claim_spec')
  end

  def build_params
    params = {
    
      
        accessModes: resource[:access_modes],
      
    
      
        selector: resource[:selector],
      
    
      
        resources: resource[:resources],
      
    
      
        volumeName: resource[:volume_name],
      
    
      
        storageClassName: resource[:storage_class_name],
      
    
      
        volumeMode: resource[:volume_mode],
      
    
      
        dataSource: resource[:data_source],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
