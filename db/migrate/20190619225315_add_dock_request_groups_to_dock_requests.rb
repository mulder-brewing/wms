class AddDockRequestGroupsToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :dock_requests, :dock_request_group, foreign_key: true
  end
end
