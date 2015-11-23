require 'puppet_x/puppetlabs/swagger/prefetch_error'
require 'puppet_x/puppetlabs/swagger/symbolize_keys'
require 'puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_endpoint_subset).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        addresses: instance.addresses.respond_to?(:to_hash) ? instance.addresses.to_hash : instance.addresses,
      
    
      
        notReadyAddresses: instance.notReadyAddresses.respond_to?(:to_hash) ? instance.notReadyAddresses.to_hash : instance.notReadyAddresses,
      
    
      
        ports: instance.ports.respond_to?(:to_hash) ? instance.ports.to_hash : instance.ports,
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating #{name}")
    create_instance_of('endpoint_subset', name, build_params)
  end

  def flush
    if ! @property_hash.empty? and @property_hash[:ensure] != :absent
      flush_instance_of('endpoint_subset', name, @property_hash[:object], build_params)
    end
  end

  def destroy
    Puppet.info("Deleting #{name}")
    destroy_instance_of('endpoint_subset', name)
  end

  private
  def self.list_instances
    list_instances_of('endpoint_subset')
  end

  def build_params
    params = {
    
      
        addresses: resource[:addresses],
      
    
      
        notReadyAddresses: resource[:notReadyAddresses],
      
    
      
        ports: resource[:ports],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end