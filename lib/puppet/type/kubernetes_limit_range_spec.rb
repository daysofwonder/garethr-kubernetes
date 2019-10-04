
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_limit_range_spec) do
  
  @doc = "LimitRangeSpec defines a min/max usage limit for resources that match on kind."
  

  ensurable
apply_to_all

  
  validate do
    required_properties = [
    
      :limits,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the limit_range_spec.'
  end
  
    
      
      newproperty(:limits, :array_matching => :all) do
      
        
        desc "Limits is the list of LimitRangeItem objects that are enforced."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
