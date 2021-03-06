
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_deployment_condition).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
        
        type: instance.type.respond_to?(:to_hash) ? instance.type.to_hash : instance.type,
        
      
    
      
        
        status: instance.status.respond_to?(:to_hash) ? instance.status.to_hash : instance.status,
        
      
    
      
        
        last_update_time: instance.lastUpdateTime.respond_to?(:to_hash) ? instance.lastUpdateTime.to_hash : instance.lastUpdateTime,
        
      
    
      
        
        last_transition_time: instance.lastTransitionTime.respond_to?(:to_hash) ? instance.lastTransitionTime.to_hash : instance.lastTransitionTime,
        
      
    
      
        
        reason: instance.reason.respond_to?(:to_hash) ? instance.reason.to_hash : instance.reason,
        
      
    
      
        
        message: instance.message.respond_to?(:to_hash) ? instance.message.to_hash : instance.message,
        
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_deployment_condition #{name}")
    create_instance_of('deployment_condition', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('deployment_condition', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_deployment_condition #{name}")
    destroy_instance_of('deployment_condition', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('deployment_condition')
  end

  def build_params
    params = {
    
      
        type: resource[:type],
      
    
      
        status: resource[:status],
      
    
      
        lastUpdateTime: resource[:last_update_time],
      
    
      
        lastTransitionTime: resource[:last_transition_time],
      
    
      
        reason: resource[:reason],
      
    
      
        message: resource[:message],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
