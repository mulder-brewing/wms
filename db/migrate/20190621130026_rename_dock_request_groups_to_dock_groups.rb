class RenameDockRequestGroupsToDockGroups < ActiveRecord::Migration[5.2]
  def change
    rename_table :dock_request_groups, :dock_groups
  end
end
