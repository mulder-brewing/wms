class AddDefaultValueToStatusForDockRequests < ActiveRecord::Migration[5.2]
  def change
    change_column_default :dock_requests, :status, "checked_in"
  end
end
