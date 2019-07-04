class AddAnotherStatusValueToDockRequests < ActiveRecord::Migration[5.2]
  def up
    execute <<-DDL
      ALTER TYPE dock_request_status ADD VALUE 'voided';
    DDL
  end
end
