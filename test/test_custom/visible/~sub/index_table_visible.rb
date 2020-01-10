class IndexTableVisible < VisibleTO

  def initialize(*)
    super
    @selector = "table.#{Table::IndexTable::TABLE_CLASS}"
  end

end
