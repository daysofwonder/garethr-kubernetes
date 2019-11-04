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
  end

  def facts
    {
      'role' => 'k8s',
      'clustername' => cluster_name,
      'mysqld_version' => '5.7.23',
      'mysqld_type' => 'mysql',
      ':mysqld_version' => '5.7.23',
      ':mysqld_type' => 'mysql'
    }
  end
end
