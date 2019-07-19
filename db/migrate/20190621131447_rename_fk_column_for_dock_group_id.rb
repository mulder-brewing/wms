class RenameFkColumnForDockGroupId < ActiveRecord::Migration[5.2]
  def change
    rename_column :dock_requests, :dock_request_group_id, :dock_group_id
  end
end
