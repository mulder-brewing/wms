class AddEnabledToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :enabled, :boolean, default: true
  end
end
