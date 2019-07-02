class AddStatusToDockRequests < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE dock_request_status AS ENUM ('checked_in', 'dock_assigned', 'checked_out');
    SQL
    add_column :dock_requests, :status, :dock_request_status, index: true
  end

  def down
    remove_column :dock_requests, :status
    execute <<-SQL
      DROP TYPE dock_request_status;
    SQL
  end
end
