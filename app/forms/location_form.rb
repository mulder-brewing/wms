class LocationForm < BasicRecordForm

  delegate  :ref, :ref=,
            :name, :name=,
            :address_1, :address_1=,
            :address_2, :address_2=,
            :city, :city=,
            :state, :state=,
            :postal_code, :postal_code=,
            :country, :country=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Location")
  end

  def initialize(*)
    super
    @table_class = Table::LocationsIndexTable
    @page_class = Page::IndexListPage
  end

  def permitted_params
    [
      :ref,
      :name,
      :address_1,
      :address_2,
      :city,
      :state,
      :postal_code,
      :country,
      :enabled
    ]
  end

end
