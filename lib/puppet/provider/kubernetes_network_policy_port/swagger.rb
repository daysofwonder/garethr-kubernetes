
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_network_policy_port).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        protocol: instance.protocol.respond_to?(:to_hash) ? instance.protocol.to_hash : instance.protocol,
      
    
      
        port: instance.port.respond_to?(:to_hash) ? instance.port.to_hash : instance.port,
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_network_policy_port #{name}")
    create_instance_of('network_policy_port', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('network_policy_port', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_network_policy_port #{name}")
    destroy_instance_of('network_policy_port', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('network_policy_port')
  end

  def build_params
    params = {
    
      
        protocol: resource[:protocol],
      
    
      
        port: resource[:port],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
