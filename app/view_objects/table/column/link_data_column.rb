class Table::Column::LinkDataColumn < Table::Column::DataColumn

  attr_accessor :remote

  def link_path(**options); end

  def link_options
    { remote: remote }
  end

end
