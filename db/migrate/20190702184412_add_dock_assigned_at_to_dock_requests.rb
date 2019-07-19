class AddDockAssignedAtToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :dock_requests, :dock_assigned_at, :datetime
  end
end
