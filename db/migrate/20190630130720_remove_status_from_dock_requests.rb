class RemoveStatusFromDockRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :dock_requests, :status
  end
end
