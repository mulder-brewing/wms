class IndexTRecordVisible < IndexTableVisible

  attr_accessor :record

  def initialize(*)
    super
    @selector << " tr##{Table::IndexTable.row_id(@record)}"
  end

end
