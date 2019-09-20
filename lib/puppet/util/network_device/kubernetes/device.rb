require 'puppet'
require 'puppet/util'
require 'puppet/util/network_device/base'
require 'puppet/util/network_device/ipcalc'
require 'puppet/util/network_device/cisco/interface'
require 'puppet/util/network_device/cisco/facts'
require 'ipaddr'

class Puppet::Util::NetworkDevice::Kubernetes::Device < Puppet::Util::NetworkDevice::Base
  def initialize(url, options = {})
  end

end
