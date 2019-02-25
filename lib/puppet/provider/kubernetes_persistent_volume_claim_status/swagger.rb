
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_persistent_volume_claim_status).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        phase: instance.phase.respond_to?(:to_hash) ? instance.phase.to_hash : instance.phase,
      
      
    
      
      
        access_modes: hash_arrays(accessModes),
      
      
    
      
      
        capacity: instance.capacity.respond_to?(:to_hash) ? instance.capacity.to_hash : instance.capacity,
      
      
    
      
      
        conditions: hash_arrays(conditions),
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_persistent_volume_claim_status #{name}")
    create_instance_of('persistent_volume_claim_status', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('persistent_volume_claim_status', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_persistent_volume_claim_status #{name}")
    destroy_instance_of('persistent_volume_claim_status', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('persistent_volume_claim_status')
  end

  def build_params
    params = {
    
      
        phase: resource[:phase],
      
    
      
        accessModes: resource[:access_modes],
      
    
      
        capacity: resource[:capacity],
      
    
      
        conditions: resource[:conditions],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
