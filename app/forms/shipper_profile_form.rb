class ShipperProfileForm < BasicRecordForm

  attr_accessor :shippers

  delegate  :shipper_id, :shipper_id=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "ShipperProfile")
  end

  def initialize(*)
    super
    @table_class = Table::ShipperProfilesIndexTable
    @page_class = Page::IndexListPage
  end

  def setup_variables
    ids = ShipperProfile.where_company(CurrentUtil.current_company_id).pluck(:shipper_id)
    @shippers = Company.type_shipper.where.not(id: ids)
  end

  def permitted_params
    [:shipper_id, :enabled]
  end

end
