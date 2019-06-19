class AddUniqueIndexToDockRequestGroups < ActiveRecord::Migration[5.2]
  def change
    add_index(:dock_request_groups, [:description, :company_id], unique: true)
  end
end
