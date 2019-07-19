class CreateDockRequestAuditHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :dock_request_audit_histories do |t|
      t.references :dock_request, foreign_key: true
      t.text :phone_number

      t.timestamps
    end
  end
end
