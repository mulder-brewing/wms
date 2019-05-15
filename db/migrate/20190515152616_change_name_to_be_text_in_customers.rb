class ChangeNameToBeTextInCustomers < ActiveRecord::Migration[5.2]
  def change
    change_column :companies, :name, :text
  end
end
