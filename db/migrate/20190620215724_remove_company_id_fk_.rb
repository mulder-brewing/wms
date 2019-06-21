class RemoveCompanyIdFk < ActiveRecord::Migration[5.2]
  def change
    remove_column :dock_requests, :company_id
  end
end
