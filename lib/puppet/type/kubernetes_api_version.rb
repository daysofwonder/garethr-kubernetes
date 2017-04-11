
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_api_version) do
  
  @doc = "An APIVersion represents a single concrete version of an object model."
  

  ensurable

  

  newparam(:name, namevar: true) do
    desc 'Name of the api_version.'
  end
  
    
      newproperty(:name) do
        
        desc "Name of this version (e.g. 'v1')."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
