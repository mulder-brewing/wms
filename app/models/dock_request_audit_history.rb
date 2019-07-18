class DockRequestAuditHistory < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :company
  belongs_to :dock_request
  belongs_to :dock, optional: true
  belongs_to :user

  enum event: { checked_in: "checked_in", dock_assigned: "dock_assigned", dock_unassigned: "dock_unassigned", text_message_sent: "text_message_sent", checked_out: "checked_out", voided: "voided", updated: "updated" }, _prefix: :event

  validates :event, presence: true
  validates :phone_number, presence: true, if: -> { event_text_message_sent? }
  validates :dock_id, presence: true, if: -> { event_dock_assigned? }

  def self.includes_user_dock_where_dock_request_id(dock_request_id)
    includes(:user).includes(:dock).where("dock_request_id = ?", dock_request_id)
  end

  def event_human_readable
    case event
    when "checked_in"
      "Checked in"
    when "dock_assigned"
      "Dock #{dock.number} assigned"
    when "dock_unassigned"
      "Dock unassigned"
    when "text_message_sent"
      "Text message sent to #{number_to_phone(phone_number, area_code: true)}"
    when "checked_out"
      "Checked out"
    when "voided"
      "Voided"
    when "updated"
      "Updated"
    end
  end
end
