
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_network_policy_spec).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        pod_selector: instance.podSelector.respond_to?(:to_hash) ? instance.podSelector.to_hash : instance.podSelector,
      
    
      
        ingress: instance.ingress.respond_to?(:to_hash) ? instance.ingress.to_hash : instance.ingress,
      
    
      
        egress: instance.egress.respond_to?(:to_hash) ? instance.egress.to_hash : instance.egress,
      
    
      
        policy_types: instance.policyTypes.respond_to?(:to_hash) ? instance.policyTypes.to_hash : instance.policyTypes,
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_network_policy_spec #{name}")
    create_instance_of('network_policy_spec', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('network_policy_spec', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_network_policy_spec #{name}")
    destroy_instance_of('network_policy_spec', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('network_policy_spec')
  end

  def build_params
    params = {
    
      
        podSelector: resource[:pod_selector],
      
    
      
        ingress: resource[:ingress],
      
    
      
        egress: resource[:egress],
      
    
      
        policyTypes: resource[:policy_types],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
