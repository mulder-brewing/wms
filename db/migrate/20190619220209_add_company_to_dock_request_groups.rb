class AddCompanyToDockRequestGroups < ActiveRecord::Migration[5.2]
  def change
    add_reference :dock_request_groups, :company, foreign_key: true
  end
end
