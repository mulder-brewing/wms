module HashUtil

  def self.to_select(h)
    return h.map {|k,v| [v,k]}
  end

end
