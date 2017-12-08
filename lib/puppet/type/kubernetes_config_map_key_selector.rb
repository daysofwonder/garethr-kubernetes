
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_config_map_key_selector) do
  
  @doc = "Selects a key from a ConfigMap."
  

  ensurable

  
  validate do
    required_properties = [
    
      :key,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the config_map_key_selector.'
  end
  
    
      newproperty(:name) do
        
        desc "Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      newproperty(:key) do
        
        desc "The key to select."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      newproperty(:optional) do
        
        desc "Specify whether the ConfigMap or it's key must be defined"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
