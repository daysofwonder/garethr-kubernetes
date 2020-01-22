require 'puppet/util/diff'
require_relative 'swagger_symbolize_keys'
require_relative 'fixnumify'
require_relative 'printer'
require 'hashdiff'

module PuppetX
  module Puppetlabs
    module Swagger
      module Differ
        include Puppet::Util::Diff

        module_function

        def property_diff_with_lcs(current_value, newvalue)
          return "defined '#{name}'" if current_value == :absent
          return "undefined '#{name}'" if [newvalue].flatten.include?(:absent)

          # compute diff
          before = is_to_s(current_value.swagger_symbolize_keys.fixnumify)
          after = should_to_s(newvalue.swagger_symbolize_keys.fixnumify)
          return "#{name} changed with diff: #{lcs_diff(before, after)}\n"
        rescue Puppet::Error
          raise
        rescue => detail
          message = _("Could not convert change '%{name}' to string: %{detail}") % { name: name, detail: detail }
          Puppet.log_exception(detail, message)
          raise Puppet::DevError, message, detail.backtrace
        end

        def property_diff_with_hashdiff(current_value, newvalue)
          return "defined '#{name}'" if current_value == :absent
          return "undefined '#{name}'" if [newvalue].flatten.include?(:absent)

          # compute diff
          before = current_value.swagger_symbolize_keys.fixnumify
          after = newvalue.swagger_symbolize_keys.fixnumify
          diffs = Hashdiff.diff(before, after, use_lcs: false)
          return "#{name} didn't change" if diffs.empty?

          decorated = decorate_diff(before, diffs)
          return "#{name} changed with diff:\n#{decorated}\n"
        rescue Puppet::Error
          raise
        rescue => detail
          message = _("Could not convert change '%{name}' to string: %{detail}") % { name: name, detail: detail }
          Puppet.log_exception(detail, message)
          raise Puppet::DevError, message, detail.backtrace
        end

        def decorate_diff(a, diffs)
          p = Printer.new(diffs)
          p.format(a)
        end
      end
    end
  end
end
