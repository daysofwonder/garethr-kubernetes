
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_subresource_reference) do
  
  @doc = "SubresourceReference contains enough information to let you inspect or modify the referred subresource."
  

  ensurable
apply_to_all

  

  newparam(:name, namevar: true) do
    desc 'Name of the subresource_reference.'
  end
  
    
  
    
      newproperty(:name) do
        
        desc "Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
  
    
      newproperty(:subresource) do
        
        desc "Subresource name of the referent"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
