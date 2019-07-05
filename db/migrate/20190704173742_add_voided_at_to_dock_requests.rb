class AddVoidedAtToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :dock_requests, :voided_at, :datetime
  end
end
