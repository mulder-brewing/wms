class Table::Column::ShowRecordColumn < Table::Column::LinkDataColumn

  def initialize(*)
    super
    @remote = true
  end

  def link_path(**options)
    Util::Paths::Show.call(options[:record])
  end

end
