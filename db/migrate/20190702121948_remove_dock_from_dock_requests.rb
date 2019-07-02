class RemoveDockFromDockRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :dock_requests, :dock, :text
  end
end
