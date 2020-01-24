class CompanyForm < BasicRecordForm

  delegate  :name, :name=,
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
    [:name, :enabled]
  end

end
