unless String.method_defined? :delete_prefix
  class String
    def delete_prefix(prefix)
      if rindex(prefix, 0)
        self[prefix.length..-1]
      else
        dup
      end
    end
  end
end

unless String.method_defined? :delete_prefix!
  class String
    def delete_prefix!(prefix)
      chomp! if frozen?
      len = prefix.length
      if len > 0 && rindex(prefix, 0)
        self[0...prefix.length] = ''
        self
      else
        nil
      end
    end
  end
end
