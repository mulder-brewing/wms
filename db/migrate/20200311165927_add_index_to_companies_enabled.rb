class AddIndexToCompaniesEnabled < ActiveRecord::Migration[6.0]
  def change
    add_index :companies, :enabled
  end
end
