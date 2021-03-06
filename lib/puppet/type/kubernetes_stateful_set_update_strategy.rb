
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_stateful_set_update_strategy) do
  
  @doc = "StatefulSetUpdateStrategy indicates the strategy that the StatefulSet controller will use to perform updates. It includes any additional parameters necessary to perform the update for the indicated strategy."
  

  ensurable
apply_to_all

  

  newparam(:name, namevar: true) do
    desc 'Name of the stateful_set_update_strategy.'
  end
  
    
      
      newproperty(:type) do
      
        
        desc "Type indicates the type of the StatefulSetUpdateStrategy. Default is RollingUpdate."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:rolling_update) do
      
        
        desc "RollingUpdate is used to communicate parameters when Type is RollingUpdateStatefulSetStrategyType."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
