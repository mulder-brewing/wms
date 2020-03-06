class CompanyForm < BasicRecordForm

  delegate  :name, :name=,
            :company_type, :company_type=,
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
    [:name, :company_type, :enabled]
  end

  private

  def save
    ActiveRecord::Base.transaction do
      record.save!
      create_defaults
    end
  end

  def create_defaults
    id = record.id
    if record.type_warehouse?
      DockGroup.create(description: "Default", company_id: id)
    end
    AccessPolicy.create(description: "Everything", company_id: id, everything: true)
  end

end
