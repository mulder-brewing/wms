class CompanyForm < BasicRecordForm

  delegate  :name, :name=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Company")
  end

  def permitted_params
    [:name, :enabled]
  end

  def table
    Table::CompaniesIndexTable.new(current_user) if action?(:create, :update)
  end

end
