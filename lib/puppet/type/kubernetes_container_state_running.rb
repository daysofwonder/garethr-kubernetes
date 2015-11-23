require 'puppet_x/puppetlabs/swagger/symbolize_keys'


Puppet::Type.newtype(:kubernetes_container_state_running) do
  
  @doc = "ContainerStateRunning is a running state of a container."
  

  ensurable

  

  newparam(:name, namevar: true) do
    desc 'Name of the container_state_running.'
  end
  
    
      newproperty(:startedAt) do
        desc "Time at which the container was last (re-)started"
        def insync?(is)
          normalized_is = is.symbolize_keys
          normalized_should = should.symbolize_keys
          if is.all? { |k,v| v.class == String }
            diff = normalized_is.merge(normalized_should)
            diff == normalized_is
          else
            tests = normalized_should.keys.collect do |key|
              normalized_is[key].collect do |is_value|
                normalized_should[key].collect do |should_value|
                  diff = is_value.merge(should_value)
                  diff == is_value
                end
              end
            end
            tests.flatten.include? true
          end
        end
      end
    
  
end