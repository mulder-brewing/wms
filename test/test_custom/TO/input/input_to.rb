class InputTO

  attr_accessor :id
  attr_writer :visible

  def initialize(id, visible = true)
    @id = id
    @visible = visible
  end

  def visible?
    @visible
  end

end
