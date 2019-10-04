
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_node_spec) do
  
  @doc = "NodeSpec describes the attributes that a node is created with."
  

  ensurable
apply_to_all

  

  newparam(:name, namevar: true) do
    desc 'Name of the node_spec.'
  end
  
    
      
      newproperty(:pod_cidr) do
      
        
        desc "PodCIDR represents the pod IP range assigned to the node."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:external_id) do
      
        
        desc "External ID of the node assigned by some machine database (e.g. a cloud provider). Deprecated."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:provider_id) do
      
        
        desc "ID of the node assigned by the cloud provider in the format: <ProviderName>://<ProviderSpecificNodeID>"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:unschedulable) do
      
        
        desc "Unschedulable controls node schedulability of new pods. By default, node is schedulable. More info: https://kubernetes.io/docs/concepts/nodes/node/#manual-node-administration"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:taints, :array_matching => :all) do
      
        
        desc "If specified, the node's taints."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:config_source) do
      
        
        desc "If specified, the source to get node configuration from The DynamicKubeletConfig feature gate must be enabled for the Kubelet to use this field"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
