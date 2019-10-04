
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_endpoint_port) do
  
  @doc = "EndpointPort is a tuple that describes a single port."
  

  ensurable
apply_to_all

  
  validate do
    required_properties = [
    
      :port,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the endpoint_port.'
  end
  
    
      
      newproperty(:name) do
      
        
        desc "The name of this port (corresponds to ServicePort.Name). Must be a DNS_LABEL. Optional only if one port is defined."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:port) do
      
        
        desc "The port number of the endpoint."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:protocol) do
      
        
        desc "The IP protocol for this port. Must be UDP or TCP. Default is TCP."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
