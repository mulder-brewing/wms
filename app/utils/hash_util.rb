module HashUtil

  def self.to_select(h)
    return [] if h.nil?
    return h.map {|k,v| [v,k]}
  end

end
