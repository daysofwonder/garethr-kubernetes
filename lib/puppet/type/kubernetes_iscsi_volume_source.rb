
# This file is automatically generated by puppet-swagger-generator and
# any manual changes are likely to be clobbered when the files
# are regenerated.

require_relative '../../puppet_x/puppetlabs/swagger/fuzzy_compare'

Puppet::Type.newtype(:kubernetes_iscsi_volume_source) do
  
  @doc = "Represents an ISCSI disk. ISCSI volumes can only be mounted as read/write once. ISCSI volumes support ownership management and SELinux relabeling."
  

  ensurable

  
  validate do
    required_properties = [
    
      :target_portal,
    
      :iqn,
    
      :lun,
    
    ]
    required_properties.each do |property|
      # We check for both places so as to cover the puppet resource path as well
      if self[property].nil? and self.provider.send(property) == :absent
        fail "You must provide a #{property}"
      end
    end
  end
  

  newparam(:name, namevar: true) do
    desc 'Name of the iscsi_volume_source.'
  end
  
    
      
      newproperty(:target_portal) do
      
        
        desc "iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260)."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:iqn) do
      
        
        desc "Target iSCSI Qualified Name."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:lun) do
      
        
        desc "iSCSI Target Lun number."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:iscsi_interface) do
      
        
        desc "iSCSI Interface Name that uses an iSCSI transport. Defaults to 'default' (tcp)."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:fs_type) do
      
        
        desc "Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: 'ext4', 'xfs', 'ntfs'. Implicitly inferred to be 'ext4' if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:read_only) do
      
        
        desc "ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:portals, :array_matching => :all) do
      
        
        desc "iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260)."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:chap_auth_discovery) do
      
        
        desc "whether support iSCSI Discovery CHAP authentication"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:chap_auth_session) do
      
        
        desc "whether support iSCSI Session CHAP authentication"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:secret_ref) do
      
        
        desc "CHAP Secret for iSCSI target and initiator authentication"
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
    
      
      newproperty(:initiator_name) do
      
        
        desc "Custom iSCSI Initiator Name. If initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface <target portal>:<volume name> will be created for the connection."
        
        def insync?(is)
          PuppetX::Puppetlabs::Swagger::Utils::fuzzy_compare(is, should)
        end
      end
    
  
end
