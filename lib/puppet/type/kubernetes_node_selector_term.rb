
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_node_selector_term) do
  
  @doc = "A null or empty node selector term matches no objects."
  

  ensurable
apply_to_all

  
  validate do
    required_properties = [
    
      :match_expressions,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the node_selector_term.'
  end
  
    
      
      newproperty(:match_expressions, :array_matching => :all) do
      
        
        desc "Required. A list of node selector requirements. The requirements are ANDed."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
