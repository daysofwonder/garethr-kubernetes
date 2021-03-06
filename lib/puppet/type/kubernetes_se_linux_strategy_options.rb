
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_se_linux_strategy_options) do
  
  @doc = "SELinux  Strategy Options defines the strategy type and any options used to create the strategy."
  

  ensurable
apply_to_all

  
  validate do
    required_properties = [
    
      :rule,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the se_linux_strategy_options.'
  end
  
    
      
      newproperty(:rule) do
      
        
        desc "type is the strategy that will dictate the allowable labels that may be set."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:se_linux_options) do
      
        
        desc "seLinuxOptions required to run as; required for MustRunAs More info: https://git.k8s.io/community/contributors/design-proposals/security_context.md"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
