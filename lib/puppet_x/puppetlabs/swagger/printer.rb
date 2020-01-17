
require_relative 'delete_prefix'

module PuppetX
  module Puppetlabs
    module Swagger
      class Printer
        attr_reader :diffs

        IDENT = '  '.freeze

        def initialize(differences)
          @diffs = differences
          # puts "diffs: #{differences}"
        end

        def format(o, level = 0, key = '')
          case o
          when Hash
            # puts "format hash at #{key}"
            format_hash(o, level + 1, key)
          when Array
            # puts "format array at #{key}"
            format_array(o, level + 1, key)
          else
            format_other(o, level + 1, key)
          end
        end

        def format_array(array, level, key)
          return '[]' if array.empty?

          data = (array + get_added_array_elements_at(key)).map.with_index do |item, idx|
            # puts "format array element #{idx} at #{key}"
            format(item, level, key + "[#{idx}]") # rubocob:disable Style/FormatString
          end
          indent = IDENT * level
          outdent = IDENT * (level - 1)
          %([\n#{indent}#{data.join(",\n")}\n#{outdent}])
        end

        def format_other(o, _level, _key)
          case o
          when Numeric
            o.to_s
          when TrueClass, FalseClass
            o ? 'true' : 'false'
          else
            %("#{o}")
          end
        end

        def format_hash(h, level, key)
          if h.empty?
            '{}'
          else
            indent = IDENT * level
            outdent = IDENT * (level - 1)
            hash_op, newval = get_prefix(key)
            # puts "key #{key} #{hash_op} #{newval}"
            outdent = if outdent.length <= hash_op.length
                        ''
                      else
                        outdent[0..(outdent.length - hash_op.length - 1)]
                      end

            first_hash_op = hash_op
            # indent hash members of array
            cond_indent = ''
            if key =~ %r{\[[1-9]\d*\]$}
              if indent.length > first_hash_op.length
                cond_indent = outdent[0..(indent.length - first_hash_op.length - 1)]
              end
            else
              first_hash_op = ''
            end

            # puts "hash: #{key}, op:'#{first_hash_op}' ci:'#{cond_indent.length}' indent:'#{indent.length}'"
            additions = get_added_hash_elements_at(key)
            printable_hash = h.merge(additions).reduce([]) do |arr, kv|
              # check key path is affected
              newkey = [key, kv[0].to_s].reject { |s| s == '' }.join('.')
              op, newval = get_prefix(newkey)
              correct_indent = if indent.length <= op.length
                                 ''
                               else
                                 indent[0..(indent.length - op.length - 1)]
                               end
              # puts "helement: #{newkey} op: #{op} newval: #{newval}"
              arr << (correct_indent || indent) + colorize_op(op) + kv[0].to_s + ' => ' + format_op(op, newkey, kv[1], newval, level)
            end
            ["#{cond_indent}#{colorize_op(first_hash_op)}{\n", printable_hash.join(",\n"), "\n#{outdent}#{colorize_op(hash_op)}}"].join
          end
        end

        def get_diff(key)
          diffs.find { |d| d[1] == key }
        end

        def get_prefix(key)
          # this finds all diffs whose key is a parent of `key`
          d = diffs.find do |diff| 
            # check diff[1] is a parent of key
            ks = key.split('.')
            ds = diff[1].split('.')
            diff[1] == key || (ks.length >= ds.length && ks.zip(ds).drop_while { |a,b| a == b }.all? { |a,b| b == nil })
          end
          return '' unless d
          [d[0] + ' ', d[3] || d[2]]
        end

        def get_added_array_elements_at(key)
          adds = diffs.select { |d| d[0] == '+' && d[1].delete_prefix(key) =~ %r{^\[\d+\]$} }
          return [] unless adds
          adds.map { |d| d[2] }
        end

        def get_added_hash_elements_at(key)
          adds = diffs.select do |d|
            d[0] == '+' && child_of(key, d[1])
          end
          return {} unless adds
          # return all added hash below key, unless it is an array add
          adds.reject { |d| d[1] =~ /\[\d+\]$/ }.reduce({}) { |a, v| a.merge(v[1].delete_prefix(key + '.') => v[2]) }
        end

        # check that b is direct child of a
        def child_of(a, b)
          return false if b.length <= a.length
          b.start_with?(a) && b.delete_prefix(a).split('.').reject { |v| v.empty? }.size == 1
        end

        def format_op(op, key, oldval, newval, level)
          oldval = format(oldval, level, key) # rubocob:disable Style/FormatString
          return oldval unless op == '~ '
          newval = format(newval, level, key) # rubocob:disable Style/FormatString
          %(#{oldval} #{yellow('~>')} #{newval})
        end

        def colorize_op(op)
          case op[0]
          when '~'
            yellow(op)
          when '+'
            green(op)
          when '-'
            red(op)
          else
            op
          end
        end

        ['gray', 'red', 'green', 'yellow', 'blue', 'purple', 'cyan', 'white'].each_with_index do |(color, _shade), i|
          define_method "bold_#{color}" do |str|
            "\e[1;#{30 + i}m#{str}\e[0m"
          end
          define_method color do |str|
            "\e[0;#{30 + i}m#{str}\e[0m"
          end
        end
      end
    end
  end
end
