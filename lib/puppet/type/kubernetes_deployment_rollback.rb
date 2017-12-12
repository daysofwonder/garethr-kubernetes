
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_deployment_rollback) do
  
  @doc = "DEPRECATED. DeploymentRollback stores the information required to rollback a deployment."
  

  ensurable

  
  validate do
    required_properties = [
    
      :name,
    
      :rollback_to,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the deployment_rollback.'
  end
  
    
  
    
  
    
      newproperty(:name) do
        
        desc "Required: This must match the Name of a deployment."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      newproperty(:updated_annotations) do
        
        desc "The annotations to be updated to a deployment"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      newproperty(:rollback_to) do
        
        desc "The config of this deployment rollback."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
