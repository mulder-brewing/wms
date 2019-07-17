class AddEventEnumToDockRequestAuditHistories < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE dock_request_audit_history_event AS ENUM ('checked_in', 'dock_assigned', 'dock_unassigned', 'text_message_sent', 'checked_out', 'voided', 'updated');
    SQL
    add_column :dock_request_audit_histories, :event, :dock_request_audit_history_event
  end

  def down
    remove_column :dock_request_audit_histories, :event
    execute <<-SQL
      DROP TYPE dock_request_audit_history_event;
    SQL
  end
end
