
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_rbd_volume_source).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        monitors: hash_arrays(monitors),
      
      
    
      
      
        image: instance.image.respond_to?(:to_hash) ? instance.image.to_hash : instance.image,
      
      
    
      
      
        fs_type: instance.fsType.respond_to?(:to_hash) ? instance.fsType.to_hash : instance.fsType,
      
      
    
      
      
        pool: instance.pool.respond_to?(:to_hash) ? instance.pool.to_hash : instance.pool,
      
      
    
      
      
        user: instance.user.respond_to?(:to_hash) ? instance.user.to_hash : instance.user,
      
      
    
      
      
        keyring: instance.keyring.respond_to?(:to_hash) ? instance.keyring.to_hash : instance.keyring,
      
      
    
      
      
        secret_ref: instance.secretRef.respond_to?(:to_hash) ? instance.secretRef.to_hash : instance.secretRef,
      
      
    
      
      
        read_only: instance.readOnly.respond_to?(:to_hash) ? instance.readOnly.to_hash : instance.readOnly,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_rbd_volume_source #{name}")
    create_instance_of('rbd_volume_source', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('rbd_volume_source', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_rbd_volume_source #{name}")
    destroy_instance_of('rbd_volume_source', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('rbd_volume_source')
  end

  def build_params
    params = {
    
      
        monitors: resource[:monitors],
      
    
      
        image: resource[:image],
      
    
      
        fsType: resource[:fs_type],
      
    
      
        pool: resource[:pool],
      
    
      
        user: resource[:user],
      
    
      
        keyring: resource[:keyring],
      
    
      
        secretRef: resource[:secret_ref],
      
    
      
        readOnly: resource[:read_only],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
