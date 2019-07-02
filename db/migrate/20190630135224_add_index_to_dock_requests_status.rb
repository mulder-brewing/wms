class AddIndexToDockRequestsStatus < ActiveRecord::Migration[5.2]
  def change
    add_index :dock_requests, :status
  end
end
