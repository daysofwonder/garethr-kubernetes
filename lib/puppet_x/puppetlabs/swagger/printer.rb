
module PuppetX
  module Puppetlabs
    module Swagger
      class Printer
        attr_reader :diffs

        IDENT = '  '

        def initialize(differences)
          @diffs = differences
        end

        def format(o, level = 0, key = "")
          case o
          when Hash
            format_hash(o, level + 1, key)
          when Array
            format_array(o, level + 1, key)
          else
            format_other(o, level + 1, key)
          end
        end

        def format_array(array, level, key)
          return "[]" if array.empty?

          data = (array + get_added_array_elements_at(key)).map.with_index do |item, idx|
            format(item, level, key + "[#{idx}]")
          end
          indent = IDENT * level
          outdent = IDENT * (level - 1)
          %Q([\n#{indent}#{data.join(",\n")}\n#{outdent}])
        end

        def format_other(o, level, key)
          case o
          when Numeric
            "#{o}"
          when TrueClass, FalseClass
            o ? 'true' : 'false'
          else
            %Q{"#{o.to_s}"}
          end
        end

        def format_hash(h, level, key)
          if h.empty?
            "{}"
          else
            indent = IDENT * level
            outdent = IDENT * (level - 1)
            hash_op, newval = get_prefix(key)
            if outdent.length <= hash_op.length
              outdent = ''
            else
              outdent = outdent[0..(outdent.length - hash_op.length - 1)]
            end

            first_hash_op = hash_op
            # indent hash members of array
            cond_indent = ''
            if key =~ /\[[1-9]\d*\]$/
              if indent.length > first_hash_op.length
                cond_indent = outdent[0..(indent.length - first_hash_op.length - 1)]
              end
            else
              first_hash_op = ''
            end

            puts "hash: #{key}, op:'#{first_hash_op}' ci:'#{cond_indent.length}' indent:'#{indent.length}'"
            printable_hash = h.reduce([]) do |arr, kv|
              # check key path is affected
              newkey = [key, kv[0].to_s].reject{ |s| s == "" }.join('.')
              op, newval = get_prefix(newkey)
              if indent.length <= op.length
                correct_indent = ''
              else
                correct_indent = indent[0..(indent.length - op.length - 1)]
              end

              arr << (correct_indent || indent) + colorize_op(op) + kv[0].to_s + ' => ' + format_op(op, newkey, kv[1], newval, level)
            end
            ["#{cond_indent}#{colorize_op(first_hash_op)}{\n", printable_hash.join(",\n"), "\n#{outdent}#{colorize_op(hash_op)}}"].join
          end
        end

        def get_diff(key)
          diffs.find { |d| d[1] == key }
        end

        def get_prefix(key)
          d = diffs.find { |d| d[1] == key || key.delete_prefix(d[1]) != key }
          return "" unless d
          [d[0] + ' ', d[2]]
        end

        def get_added_array_elements_at(key)
          adds = diffs.select { |d| d[0] == '+' && d[1].delete_prefix(key) =~ /^\[\d+\]$/ }
          return [] unless adds
          adds.map{ |d| d[2] }
        end

        def format_op(op, key, oldval, newval, level)
          oldval = format(oldval, level, key)
          return oldval unless op == '~ '
          newval = format(newval, level, key)
          %Q{#{oldval} #{yellow('~>')} #{newval}}
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

        %w(gray red green yellow blue purple cyan white).each_with_index do |(color, shade), i|
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

