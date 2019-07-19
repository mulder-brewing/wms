class AddDockToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :dock_requests, :dock, foreign_key: true
  end
end
