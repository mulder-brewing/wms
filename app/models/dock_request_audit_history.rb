class DockRequestAuditHistory < ApplicationRecord
  belongs_to :company
  belongs_to :dock_request
  belongs_to :dock, optional: true

  enum event: { checked_in: "checked_in", dock_assigned: "dock_assigned", dock_unassigned: "dock_unassigned", text_message_sent: "text_message_sent", checked_out: "checked_out", voided: "voided", updated: "updated" }, _prefix: :event

  validates :event, presence: true
  validates :phone_number, presence: true, if: -> { event_text_message_sent? }
  validates :dock_id, presence: true, if: -> { event_dock_assigned? }

  def self.where_dock_request_id(dock_request_id)
    where("dock_request_id = ?", dock_request_id)
  end
end
