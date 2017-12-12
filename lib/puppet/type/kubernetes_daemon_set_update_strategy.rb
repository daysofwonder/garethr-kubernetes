
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_daemon_set_update_strategy) do
  

  ensurable

  

  newparam(:name, namevar: true) do
    desc 'Name of the daemon_set_update_strategy.'
  end
  
    
      newproperty(:type) do
        
        desc "Type of daemon set update. Can be 'RollingUpdate' or 'OnDelete'. Default is OnDelete."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      newproperty(:rolling_update) do
        
        desc "Rolling update config params. Present only if type = 'RollingUpdate'."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
