
class Table::Auth::UsersIndexTable < Table::IndexTable

  COMPANY_COLUMN_TEST_ID = "user-company-column-test-id"

  def initialize(current_user)
    super(current_user)
    buttons = [Button::IndexEditButton.new]
    buttons << Button::BecomeButton.new if app_admin?
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new("auth/users.name.username",
      :username)
    if app_admin?
      company_column = Table::Column::DataColumn.new("companies.company",
        [:company, :name])
      company_column.id = COMPANY_COLUMN_TEST_ID
      @columns << company_column
    end
    @columns << Table::Column::EnabledColumn.new
  end
end
