module StringUtil

  def self.digits_only(s)
    return s.to_s.scan(/\d/).join('')
  end

end
