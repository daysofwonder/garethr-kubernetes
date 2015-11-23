require 'puppet_x/puppetlabs/swagger/prefetch_error'
require 'puppet_x/puppetlabs/swagger/symbolize_keys'
require 'puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_load_balancer_ingress).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        ip: instance.ip.respond_to?(:to_hash) ? instance.ip.to_hash : instance.ip,
      
    
      
        hostname: instance.hostname.respond_to?(:to_hash) ? instance.hostname.to_hash : instance.hostname,
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating #{name}")
    create_instance_of('load_balancer_ingress', name, build_params)
  end

  def flush
    if ! @property_hash.empty? and @property_hash[:ensure] != :absent
      flush_instance_of('load_balancer_ingress', name, @property_hash[:object], build_params)
    end
  end

  def destroy
    Puppet.info("Deleting #{name}")
    destroy_instance_of('load_balancer_ingress', name)
  end

  private
  def self.list_instances
    list_instances_of('load_balancer_ingress')
  end

  def build_params
    params = {
    
      
        ip: resource[:ip],
      
    
      
        hostname: resource[:hostname],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end