
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_downward_api_projection) do
  
  @doc = "Represents downward API info for projecting into a projected volume. Note that this is identical to a downwardAPI volume source without the default mode."
  

  ensurable
apply_to_all

  

  newparam(:name, namevar: true) do
    desc 'Name of the downward_api_projection.'
  end
  
    
      
      newproperty(:items, :array_matching => :all) do
      
        
        desc "Items is a list of DownwardAPIVolume file"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
