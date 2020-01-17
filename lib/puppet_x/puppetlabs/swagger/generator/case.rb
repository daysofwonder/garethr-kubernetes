class String
  def swagger_to_snake_case
    gsub(%r{([A-Z]+)([A-Z][a-z])}, '\1_\2').gsub(%r{([a-z\d])([A-Z])}, '\1_\2').tr('-', '_').downcase
  end

  def swagger_to_camel_back
    split('_').reduce([]) { |b, e| b.push(b.empty? ? e : e.capitalize) }.join
  end
end
