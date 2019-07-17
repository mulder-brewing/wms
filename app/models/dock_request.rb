class DockRequest < ApplicationRecord
  # Need both of these to use the distance_of_time_in_words
  require 'action_view'
  include ActionView::Helpers::DateHelper
  include DockGroupChecks

  # Class instance variable
    # Messages to the user in alert
    @checked_out_alert_message = "Already checked out."
    @voided_alert_message = "Already voided."
    @dock_assigned_alert_message = "Dock has already been assigned."
    @dock_unassigned_alert_message = "Dock has already been unassigned."
    @no_enabled_docks_to_assign_alert_message = "There are no enabled docks for this dock group to assign."
    @no_longer_exists_alert_message = "Dock request no longer exists."

    # Errors added to the instance under certain circumstances.
    @status_error_checked_out_or_voided = "Cannot update a dock request that is checked out or voided."
    @dock_id_error_message_zero_docks = "There are no enabled docks for this dock group."
    @status_error_no_longer_checked_in = "Status is no longer checked in."
    @status_error_no_longer_dock_assigned = "Dock cannot be unassigned because the status is no longer dock assigned."

  attr_accessor :context
  attr_accessor :number_of_enabled_docks_within_dock_group

  enum status: { checked_in: "checked_in", dock_assigned: "dock_assigned", checked_out: "checked_out", voided: "voided" }, _prefix: :status

  belongs_to :company
  belongs_to :dock_group
  belongs_to :dock, optional: true
  has_many :dock_request_audit_histories, dependent: :destroy

  before_validation :clean_phone_number

  validates :primary_reference, presence: true
  validates :dock_id, presence: true, if: :context_dock_assignment_update?
  VALID_PHONE_REGEX = /\A\d{10}\z/
  validates :phone_number, length: { is: 10 }, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validate :phone_number_if_text_message
  validate :ok_to_update, if: :context_edit_or_update?
  validate :dock_assignment_edit, if: :context_dock_assignment_edit?
  validate :dock_assignment_update, if: :context_dock_assignment_update?
  validate :dock_unassign_update, if: :context_dock_unassign?
  validate :check_out_update, if: :context_check_out?
  validate :void_update, if: :context_void?


  scope :active, -> { where("status != ? AND status != ?", "checked_out", "voided") }
  scope :include_docks, -> { includes(:dock) }

  after_update_commit :send_sms, if: :context_dock_assignment_update?
  after_commit :create_audit_history_entry, on: [:create, :update]



  def self.where_company_and_group(current_company_id, group_id)
    where("company_id = ? AND dock_group_id = ?", current_company_id, group_id)
  end

  # This is the text used in the alert message when a dock request is already checked out.
  def self.checked_out_alert_message
    @checked_out_alert_message
  end

  # This is the text used in the alert message when a dock request is already voided.
  def self.voided_alert_message
    @voided_alert_message
  end

  # This is the text used in the alert message when a dock has already been assigned.
  def self.dock_assigned_alert_message
    @dock_assigned_alert_message
  end

  # This is the text used in the alert message when a dock has already been unassigned.
  def self.dock_unassigned_alert_message
    @dock_unassigned_alert_message
  end

  # This is the text used in the alert message when there are no enabled docks that could be assigned.
  def self.no_enabled_docks_to_assign_alert_message
    @no_enabled_docks_to_assign_alert_message
  end

  # This is the text used in the alert message when a dock request no longer exists.
  def self.no_longer_exists_alert_message
    @no_longer_exists_alert_message
  end

  # This is the error message added for status when the dock request is already checked out or voided.
  def self.status_error_checked_out_or_voided
    @status_error_checked_out_or_voided
  end

  # This is the error message added for dock_id when there are no enabled docks that could be assigned.
  def self.dock_id_error_message_zero_docks
    @dock_id_error_message_zero_docks
  end

  # This is the error message added for status when the dock request is no longer checked in.
  def self.status_error_no_longer_checked_in
    @status_error_no_longer_checked_in
  end

  # This is the error message added for status when the dock request is no longer dock assigned.
  def self.status_error_no_longer_dock_assigned
    @status_error_no_longer_dock_assigned
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

  def name_with_id
    "dock_request_#{id}"
  end

  def target_for_jquery
    "#" + name_with_id
  end

  private

    def context_dock_assignment_edit?
      context == "dock_assignment_edit"
    end

    def context_dock_assignment_update?
      context == "dock_assignment_update"
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

    def context_edit_or_update?
      context == "edit" || context == "update"
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
      if text_message && !Rails.env.test?
        sns = Aws::SNS::Client.new(region: ENV["AWS_REGION"], access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
        sns.set_sms_attributes(attributes: { "DefaultSenderID" => "MulderWMS", "DefaultSMSType" => "Transactional" })
        sns.publish(phone_number: phone_number_for_sms, message: "Dock #{dock.number} is ready for you.  Please back in ASAP.")
        #=> #<struct Aws::SNS::Types::PublishResponse...>
      end
    end

    def dock_assignment_edit
      errors.add(:status, DockRequest.status_error_no_longer_checked_in) if !status_checked_in?
      if number_of_enabled_docks_within_dock_group == 0
        errors.add(:dock_id, DockRequest.dock_id_error_message_zero_docks)
      end
    end

    def dock_assignment_update
      if status_checked_in?
        self.status = "dock_assigned"
        self.dock_assigned_at = DateTime.now
      else
        errors.add(:status, DockRequest.status_error_no_longer_checked_in)
      end
    end

    def dock_unassign_update
      if status_dock_assigned?
        self.status = "checked_in"
        self.dock_id = nil
        self.dock_assigned_at = nil
      else
        errors.add(:status, DockRequest.status_error_no_longer_dock_assigned)
      end
    end

    def check_out_update
      if status_dock_assigned?
        self.status = "checked_out"
        self.checked_out_at = DateTime.now
      else
        errors.add(:status, DockRequest.status_error_no_longer_dock_assigned)
      end
    end

    def void_update
      if status_checked_in?
        self.status = "voided"
        self.voided_at = DateTime.now
      else
        errors.add(:status, DockRequest.status_error_no_longer_checked_in)
      end
    end

    def ok_to_update
      if status_checked_out? || status_voided?
        errors.add(:status, DockRequest.status_error_checked_out_or_voided)
      end
    end

    def create_audit_for_me_with(hash)
      attributes = { :dock_request_id => id, :company_id => company_id }.merge(hash)
      DockRequestAuditHistory.create(attributes)
    end

    def create_audit_history_entry
      if !context.nil?
        case context
        when "create"
          create_audit_for_me_with({ :event => "checked_in" })
        when "update"
          create_audit_for_me_with({ :event => "updated" })
        when "dock_assignment_update"
          create_audit_for_me_with({ :event => "dock_assigned", :dock_id => dock_id })
          create_audit_for_me_with({ :event => "text_message_sent", :phone_number => phone_number }) if text_message
        when "dock_unassign"
          create_audit_for_me_with({ :event => "dock_unassigned" })
        when "void"
          create_audit_for_me_with({ :event => "voided" })
        when "check_out"
          create_audit_for_me_with({ :event => "checked_out" })
        end
      end
    end
end
