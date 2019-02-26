
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_scale_spec) do
  
  @doc = "describes the attributes of a scale subresource"
  

  ensurable

  

  newparam(:name, namevar: true) do
    desc 'Name of the scale_spec.'
  end
  
    
      
      newproperty(:replicas) do
      
        
        desc "desired number of instances for the scaled object."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
