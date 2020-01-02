
class Table::Auth::UsersIndexTable < Table::IndexTable
  def initialize(current_user)
    super(current_user)
    buttons = [Button::EditButton.new, Button::BecomeButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new("auth/users.name.username",
      :username)
    @columns << Table::Column::DataColumn.new("companies.company",
      [:company, :name])
    @columns << Table::Column::EnabledColumn.new
  end
end
