class Order::OrderGroupForm < BasicRecordForm

  delegate  :description, :description=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Order::OrderGroup")
  end

  def initialize(*)
    super
    @table_class = Table::Order::OrderGroupsIndexTable
    @page_class = Page::IndexListPage
  end

  def permitted_params
    [:description, :enabled]
  end

end
