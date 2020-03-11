class AddLegitimateToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :legitimate, :boolean
    add_index :companies, :legitimate
  end
end
