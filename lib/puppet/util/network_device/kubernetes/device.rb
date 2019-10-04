require 'puppet'
require 'puppet/util/network_device'
require 'puppet/util/network_device/kubernetes'

class Puppet::Util::NetworkDevice::Kubernetes::Device
  attr_reader :kubeclient_config

  def initialize(url, options = {})
    uri = URI.parse(url)
    raise "Device url is not a file:// uri" unless uri.scheme == 'file'
    raise "Device url doesn't exist" unless File.exists?(uri.path)
    @kubeclient_config = uri.path
  end

  def facts
    {
      'role' => 'k8s'
    }
  end
end
