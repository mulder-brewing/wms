class AddCheckedOutAtToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :dock_requests, :checked_out_at, :datetime
  end
end
