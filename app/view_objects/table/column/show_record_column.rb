class Table::Column::ShowRecordColumn < Table::Column::LinkDataColumn

  def initialize(*)
    super
    @remote = true
  end

  def link_path(**options)
    PathUtil.show(options[:record])
  end

end
