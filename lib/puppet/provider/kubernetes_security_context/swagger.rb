require 'puppet_x/puppetlabs/swagger/prefetch_error'
require 'puppet_x/puppetlabs/swagger/symbolize_keys'
require 'puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_security_context).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        capabilities: instance.capabilities.respond_to?(:to_hash) ? instance.capabilities.to_hash : instance.capabilities,
      
    
      
        privileged: instance.privileged.respond_to?(:to_hash) ? instance.privileged.to_hash : instance.privileged,
      
    
      
        seLinuxOptions: instance.seLinuxOptions.respond_to?(:to_hash) ? instance.seLinuxOptions.to_hash : instance.seLinuxOptions,
      
    
      
        runAsUser: instance.runAsUser.respond_to?(:to_hash) ? instance.runAsUser.to_hash : instance.runAsUser,
      
    
      
        runAsNonRoot: instance.runAsNonRoot.respond_to?(:to_hash) ? instance.runAsNonRoot.to_hash : instance.runAsNonRoot,
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating #{name}")
    create_instance_of('security_context', name, build_params)
  end

  def flush
    if ! @property_hash.empty? and @property_hash[:ensure] != :absent
      flush_instance_of('security_context', name, @property_hash[:object], build_params)
    end
  end

  def destroy
    Puppet.info("Deleting #{name}")
    destroy_instance_of('security_context', name)
  end

  private
  def self.list_instances
    list_instances_of('security_context')
  end

  def build_params
    params = {
    
      
        capabilities: resource[:capabilities],
      
    
      
        privileged: resource[:privileged],
      
    
      
        seLinuxOptions: resource[:seLinuxOptions],
      
    
      
        runAsUser: resource[:runAsUser],
      
    
      
        runAsNonRoot: resource[:runAsNonRoot],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end