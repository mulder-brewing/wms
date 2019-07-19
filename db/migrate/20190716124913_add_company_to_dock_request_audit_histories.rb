class AddCompanyToDockRequestAuditHistories < ActiveRecord::Migration[5.2]
  def change
    add_reference :dock_request_audit_histories, :company, foreign_key: true
  end
end
