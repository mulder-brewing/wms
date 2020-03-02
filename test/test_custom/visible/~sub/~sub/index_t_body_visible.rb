class IndexTBodyVisible < IndexTableVisible

  def initialize(*)
    super
    @selector << " .#{Table::IndexTable::BODY_CLASS}"
  end
  
end
