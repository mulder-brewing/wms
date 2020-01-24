class Table::DockRequestsIndexTable < Table::IndexTable

  def initialize(*)
    super
    @insert_method = Table::Insert::APPEND
  end

end
