
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_env_from_source) do
  
  @doc = "EnvFromSource represents the source of a set of ConfigMaps"
  

  ensurable

  

  newparam(:name, namevar: true) do
    desc 'Name of the env_from_source.'
  end
  
    
      
      newproperty(:prefix) do
      
        
        desc "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:config_map_ref) do
      
        
        desc "The ConfigMap to select from"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:secret_ref) do
      
        
        desc "The Secret to select from"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
