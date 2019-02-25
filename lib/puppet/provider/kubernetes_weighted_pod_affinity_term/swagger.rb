
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_weighted_pod_affinity_term).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        weight: instance.weight.respond_to?(:to_hash) ? instance.weight.to_hash : instance.weight,
      
      
    
      
      
        pod_affinity_term: instance.podAffinityTerm.respond_to?(:to_hash) ? instance.podAffinityTerm.to_hash : instance.podAffinityTerm,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_weighted_pod_affinity_term #{name}")
    create_instance_of('weighted_pod_affinity_term', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('weighted_pod_affinity_term', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_weighted_pod_affinity_term #{name}")
    destroy_instance_of('weighted_pod_affinity_term', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('weighted_pod_affinity_term')
  end

  def build_params
    params = {
    
      
        weight: resource[:weight],
      
    
      
        podAffinityTerm: resource[:pod_affinity_term],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
