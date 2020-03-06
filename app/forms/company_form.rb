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

end
