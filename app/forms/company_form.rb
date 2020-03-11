class CompanyForm < BasicRecordForm

  delegate  :name, :name=,
            :company_type, :company_type=,
            :legitimate, :legitimate=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Company")
  end

  def initialize(*)
    super
    @table_class = Table::CompaniesIndexTable
    @page_class = Page::IndexListPage
  end

  def permitted_params
    [:name, :company_type, :legitimate, :enabled]
  end

  private

  def save
    ActiveRecord::Base.transaction do
      id_b4_save = record.id
      record.save!
      create_defaults if id_b4_save.nil?
    end
  end

  def create_defaults
    id = record.id
    default = "Default"
    if record.type_warehouse?
      DockGroup.create(description: default, company_id: id)
      Order::OrderGroup.create(description: default, company_id: id)
    end
    AccessPolicy.create(description: "Everything", company_id: id, everything: true)
  end

end
