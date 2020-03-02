class IndexTHeadVisible < IndexTableVisible

  def initialize(*)
    super
    @selector << " .#{Table::IndexTable::HEAD_CLASS}"
  end

end
