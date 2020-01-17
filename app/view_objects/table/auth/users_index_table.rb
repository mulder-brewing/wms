
class Table::Auth::UsersIndexTable < Table::IndexTable

  COMPANY_COLUMN_TEST_ID = "user-company-column-test-id"

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new]
    buttons << Button::BecomeButton.new if app_admin?
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(t_class: Auth::User,
      attribute: :username)
    if app_admin?
      company_column = Table::Column::DataColumn.new(
        title: model_sing(Company), send_chain: [:company, :name])
      company_column.id = COMPANY_COLUMN_TEST_ID
      @columns << company_column
    end
    @columns << Table::Column::EnabledColumn.new
  end
end
