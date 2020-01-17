class Table::Column::ActionColumn < Table::Column::IndexColumn

  def initialize(*)
    @text_key = "global.actions"
  end

  def actions?
    true
  end

end
