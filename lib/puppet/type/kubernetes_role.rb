
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_role) do
  
  @doc = "Role is a namespaced, logical grouping of PolicyRules that can be referenced as a unit by a RoleBinding."
  

  ensurable
apply_to_all

  
  validate do
    required_properties = [
    
      :rules,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the role.'
  end
  
    
  
    
  
    
      
      newproperty(:metadata) do
      
        
        desc "Standard object's metadata."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:rules, :array_matching => :all) do
      
        
        desc "Rules holds all the PolicyRules for this Role"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
