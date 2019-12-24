require 'puppet/util/diff'
require_relative 'swagger_symbolize_keys'
require_relative 'fixnumify'
require_relative 'printer'
require 'hashdiff'

module PuppetX
  module Puppetlabs
    module Swagger
      include Puppet::Util::Diff

      def property_diff_with_lcs(current_value, newvalue)
        begin
          if current_value == :absent
            return "defined '#{name}'"
          elsif newvalue == :absent or newvalue == [:absent]
            return "undefined '#{name}'"
          else
            # compute diff
            before = is_to_s(current_value.swagger_symbolize_keys.fixnumify)
            after = should_to_s(newvalue.swagger_symbolize_keys.fixnumify)
            return "#{name} changed with diff: #{lcs_diff(before, after)}\n"
          end
        rescue Puppet::Error
          raise
        rescue => detail
          message = _("Could not convert change '%{name}' to string: %{detail}") % { name: name, detail: detail }
          Puppet.log_exception(detail, message)
          raise Puppet::DevError, message, detail.backtrace
        end
      end


      def property_diff_with_hashdiff(current_value, newvalue)
        begin
          if current_value == :absent
            return "defined '#{name}'"
          elsif newvalue == :absent or newvalue == [:absent]
            return "undefined '#{name}'"
          else
            # compute diff
            before = current_value.swagger_symbolize_keys.fixnumify
            after = newvalue.swagger_symbolize_keys.fixnumify
            diffs = Hashdiff.diff(before, after, :use_lcs => false)
            decorated = decorate_diff(before, diffs)
            return "#{name} changed with diff: \n#{diffs}\n#{decorated}\n"
          end
        rescue Puppet::Error
          raise
        rescue => detail
          message = _("Could not convert change '%{name}' to string: %{detail}") % { name: name, detail: detail }
          Puppet.log_exception(detail, message)
          raise Puppet::DevError, message, detail.backtrace
        end
      end

# [["-", "progressDeadlineSeconds", 600], ["-", "replicas", 1], ["-", "revisionHistoryLimit", 10], ["-", "strategy", {:type=>"RollingUpdate", :rollingUpdate=>{:maxUnavailable=>"25%", :maxSurge=>"25%"}}], ["-", "template.metadata.creationTimestamp", nil], ["-", "template.spec.dnsPolicy", "ClusterFirst"], ["-", "template.spec.restartPolicy", "Always"], ["-", "template.spec.schedulerName", "default-scheduler"], ["-", "template.spec.securityContext", {}], ["-", "template.spec.terminationGracePeriodSeconds", 30], ["-", "template.spec.containers[0].imagePullPolicy", "Always"], ["-", "template.spec.containers[0].resources", {}], ["-", "template.spec.containers[0].terminationMessagePath", "/dev/termination-log"], ["-", "template.spec.containers[0].terminationMessagePolicy", "File"], ["+", "template.spec.containers[0].env[1]", {:name=>"TEST4", :value=>"VALUE2"}], ["~", "template.spec.containers[0].name", "hello-world2", "hello-world"]]


      def decorate_diff(a, diffs)
        p = Printer.new(diffs)
        p.format(a)
      end


    end
  end
end
