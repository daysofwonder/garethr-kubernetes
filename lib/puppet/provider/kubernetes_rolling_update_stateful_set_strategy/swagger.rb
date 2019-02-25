
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_rolling_update_stateful_set_strategy).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
    ensure: :present,
    name: instance.metadata.name,
    
      
      
        partition: instance.partition.respond_to?(:to_hash) ? instance.partition.to_hash : instance.partition,
      
      
    
    object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_rolling_update_stateful_set_strategy #{name}")
    create_instance_of('rolling_update_stateful_set_strategy', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('rolling_update_stateful_set_strategy', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_rolling_update_stateful_set_strategy #{name}")
    destroy_instance_of('rolling_update_stateful_set_strategy', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('rolling_update_stateful_set_strategy')
  end

  def build_params
    params = {
    
      
        partition: resource[:partition],
      
    
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
