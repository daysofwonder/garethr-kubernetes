
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../../puppet_x/puppetlabs/kubernetes/provider'

Puppet::Type.type(:kubernetes_validating_webhook_configuration).provide(:swagger, :parent => PuppetX::Puppetlabs::Kubernetes::Provider) do

  mk_resource_methods

  def self.instance_to_hash(instance)
    {
      ensure: :present,
      name: instance_name(instance),
      metadata: instance.metadata.respond_to?(:to_hash) ? instance.metadata.to_hash : instance.metadata,
      webhooks: hash_arrays(instance.webhooks),
      object: instance,
    }
  end

  def create
    Puppet.info("Creating kubernetes_validating_webhook_configuration #{name}")
    create_instance_of('validating_webhook_configuration', name, build_params)
  end

  def flush
   unless @property_hash.empty?
     unless resource[:ensure] == :absent
        flush_instance_of('validating_webhook_configuration', name, @property_hash[:object], build_params)
      end
    end
  end

  def destroy
    Puppet.info("Deleting kubernetes_validating_webhook_configuration #{name}")
    destroy_instance_of('validating_webhook_configuration', name)
    @property_hash[:ensure] = :absent
  end

  private
  def self.list_instances
    list_instances_of('validating_webhook_configuration')
  end

  def build_params
    params = {
      metadata: resource[:metadata],
      webhooks: resource[:webhooks],
    }
    params.delete_if { |key, value| value.nil? }
    params
  end
end
