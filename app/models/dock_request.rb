class DockRequest < ApplicationRecord
  # Need both of these to use the distance_of_time_in_words
  require 'action_view'
  include ActionView::Helpers::DateHelper

  enum status: { checked_in: "checked_in", dock_assigned: "dock_assigned", checked_out: "checked_out", voided: "voided" }, _prefix: :status

  attr_accessor :context

  belongs_to :company
  belongs_to :dock_group
  belongs_to :dock, optional: true

  before_validation :clean_phone_number
  before_validation :dock_assignment_update, if: :context_dock_assignment?
  before_validation :dock_unassign_update, if: :context_dock_unassign?
  before_validation :check_out_update, if: :context_check_out?
  before_validation :void_update, if: :context_void?

  validates :primary_reference, presence: true
  validates :dock_id, presence: true, if: :context_dock_assignment?
  VALID_PHONE_REGEX = /\A\d{10}\z/
  validates :phone_number, length: { is: 10 }, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validate :phone_number_if_text_message
  validate :dock_group_enabled, if: :dock_group_id_exists?
  validate :dock_group_company_match, if: :dock_group_id_exists?

  scope :active, -> { where("status != ? AND status != ?", "checked_out", "voided") }
  scope :include_docks, -> { includes(:dock) }

  after_update_commit :send_sms, if: :context_dock_assignment?

  def self.where_company_and_group(current_company_id, group_id)
    where("company_id = ? AND dock_group_id = ?", current_company_id, group_id)
  end

  def total_time
    if status_checked_out?
      distance_of_time_in_words(created_at.beginning_of_minute, checked_out_at.beginning_of_minute)
    elsif status_voided?
      distance_of_time_in_words(created_at.beginning_of_minute, voided_at.beginning_of_minute)
    else
      distance_of_time_in_words(created_at.beginning_of_minute, DateTime.now.beginning_of_minute)
    end
  end

  def dock_number_if_assigned
    if !dock_id.blank?
      dock.number
    end
  end

  def status_human_readable
    case status
    when "checked_in"
      "Checked In"
    when "dock_assigned"
      "Dock Assigned"
    when "checked_out"
      "Checked Out"
    when "voided"
      "Voided"
    end
  end

  private
    def context_dock_assignment?
      context == "dock_assignment"
    end

    def context_dock_unassign?
      context == "dock_unassign"
    end

    def context_check_out?
      context == "check_out"
    end

    def context_void?
      context == "void"
    end

    def phone_number_if_text_message
      if text_message && phone_number.blank?
        errors.add(:phone_number, "can't be blank if you want to send a text message.")
      end
    end

    def clean_phone_number
      if !phone_number.blank?
        self.phone_number = digits_only(phone_number)
      end
    end

    def phone_number_for_sms
      "+1" + phone_number
    end

    def send_sms
      if text_message
        sns = Aws::SNS::Client.new(region: ENV["AWS_REGION"], access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
        sns.set_sms_attributes(attributes: { "DefaultSenderID" => "MulderWMS", "DefaultSMSType" => "Transactional" })
        sns.publish(phone_number: phone_number_for_sms, message: "Dock #{dock.number} is ready for you.  Please back in ASAP.")
        #=> #<struct Aws::SNS::Types::PublishResponse...>
      end
    end

    def dock_assignment_update
      self.status = "dock_assigned"
      self.dock_assigned_at = DateTime.now
    end

    def dock_unassign_update
      self.status = "checked_in"
      self.dock_id = nil
      self.dock_assigned_at = nil
    end

    def check_out_update
      self.status = "checked_out"
      self.checked_out_at = DateTime.now
    end

    def void_update
      self.status = "voided"
      self.voided_at = DateTime.now
    end

    def dock_group_id_exists?
      !dock_group_id.blank?
    end

    def dock_group_enabled
      if dock_group.enabled == false
        errors.add(:base, "Dock group #{dock_group.description} is disabled.")
      end
    end

    def dock_group_company_match
      if dock_group.company_id != company_id
        errors.add(:dock_group_id, "does not belong to your company")
      end
    end
end
