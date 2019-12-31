class Table::Column::ButtonColumn < Table::Column::ActionColumn

  attr_accessor :buttons

  def initialize(buttons)
    super()
    @buttons = buttons
  end

  def buttons?
    !@buttons.empty?
  end

end
