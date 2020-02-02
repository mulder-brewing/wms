class DockQueue::DockRequestAuditHistory < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :company
  belongs_to :dock_request, class_name: "DockQueue::DockRequest"
  belongs_to :dock, optional: true
  belongs_to :user, class_name: "Auth::User"

  enum event: { checked_in: "checked_in", dock_assigned: "dock_assigned",
    dock_unassigned: "dock_unassigned", text_message_sent: "text_message_sent",
    checked_out: "checked_out", voided: "voided", updated: "updated" }, _prefix: :event

  validates :event, presence: true
  validates :phone_number, presence: true, if: -> { event_text_message_sent? }
  validates :dock_id, presence: true, if: -> { event_dock_assigned? }

  def self.includes_user_dock_where_dock_request_id(dock_request_id)
    includes(:user).includes(:dock).where("dock_request_id = ?", dock_request_id)
  end

  def event_human_readable
    options = {}
    case event
    when "dock_assigned"
      options[:number] = dock.number
    when "text_message_sent"
      options[:number] = number_to_phone(phone_number, area_code: true)
    end
    human_attribute_name("event." + event, options)
  end

end
