class Table::Column::ActionColumn < Table::Column::IndexColumn

  def initialize
    super("global.actions")
  end

  def actions?
    true
  end

end
