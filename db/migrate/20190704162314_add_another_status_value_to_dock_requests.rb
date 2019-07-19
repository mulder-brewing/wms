class AddAnotherStatusValueToDockRequests < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def up
    execute %{
      ALTER TYPE dock_request_status ADD VALUE 'voided';
    }
  end
end
