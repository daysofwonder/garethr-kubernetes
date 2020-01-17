class Object
  def swagger_symbolize_keys
    return each_with_object({}) { |(k, v), memo| memo[k.to_sym] = v.swagger_symbolize_keys; } if is_a? Hash
    return each_with_object([]) { |v, memo| memo << v.swagger_symbolize_keys; } if is_a? Array
    self
  end
end
