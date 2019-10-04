
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_network_policy_port) do
  

  ensurable
apply_to_all

  

  newparam(:name, namevar: true) do
    desc 'Name of the network_policy_port.'
  end
  
    
      
      newproperty(:protocol) do
      
        
        desc "Optional.  The protocol (TCP or UDP) which traffic must match. If not specified, this field defaults to TCP."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:port) do
      
        
        desc "If specified, the port on the given protocol.  This can either be a numerical or named port on a pod.  If this field is not provided, this matches all port names and numbers. If present, only traffic on the specified protocol AND port will be matched."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
