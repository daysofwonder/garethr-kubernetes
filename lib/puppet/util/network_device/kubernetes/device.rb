require 'puppet'
require 'puppet/util/network_device'
require 'puppet/util/network_device/kubernetes'

class Puppet::Util::NetworkDevice::Kubernetes::Device
  attr_reader :kubeclient_config
  attr_reader :cluster_name

  def initialize(url, options = {})
    uri = URI.parse(url)
    raise "Device url is not a file:// uri" unless uri.scheme == 'file'
    raise "Device url doesn't exist" unless File.exists?(uri.path)
    @kubeclient_config = uri.path
    @cluster_name = Puppet.settings[:certname]
    if uri.query
      require 'cgi'
      params = CGI.parse(uri.query)
      if Array(params['clustername']).flatten.size > 0
        @cluster_name = params['clustername'].first
      end
    end

    load_facts
  end

  def load_facts
    Facter.reset
    dirs = []
    Puppet.lookup(:current_environment).modules.each do |m|
      if m.has_external_facts?
        dir = m.plugin_fact_directory
        Puppet.debug "Loading external facts from #{dir}"
        dirs << dir
      end
    end
    # Add system external fact directory if it exists
    if FileTest.directory?(Puppet[:pluginfactdest])
      dir = Puppet[:pluginfactdest]
      Puppet.debug "Loading external facts from #{dir}"
      dirs << dir
    end
    Facter.search_external dirs

    Facter.search(Puppet[:factpath].split(File::PATH_SEPARATOR))
  end

  def facts
    {
      'role' => 'k8s',
      'clustername' => cluster_name,
    }
  end
end
