class AccessPolicyForm < BasicRecordForm

  delegate  :description, :description=,
            :enabled, :enabled=,
            :everything, :everything=,
            :dock_queue, :dock_queue=,
            :dock_groups, :dock_groups=,
            :docks, :docks=,
            :order_order_groups, :order_order_groups=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "AccessPolicy")
  end

  def initialize(*)
    super
    @table_class = Table::AccessPoliciesIndexTable
    @page_class = Page::IndexListPage
  end

  def permitted_params
    [
      :description,
      :enabled,
      :everything,
      :dock_queue,
      :dock_groups,
      :docks,
      :order_order_groups
    ]
  end

end
