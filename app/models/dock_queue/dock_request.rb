class DockQueue::DockRequest < ApplicationRecord
  # Need both of these to use the distance_of_time_in_words
  require 'action_view'
  include ActionView::Helpers::DateHelper

  enum status: {
    checked_in: "checked_in",
    dock_assigned: "dock_assigned",
    checked_out: "checked_out",
    voided: "voided"
  }, _prefix: :status

  belongs_to :company
  belongs_to :dock_group
  belongs_to :dock, optional: true
  has_many :dock_request_audit_histories, dependent: :destroy

  before_validation :clean_phone_number

  validates :primary_reference, presence: true
  validates :phone_number,
            length: { is: 10 },
            format: { with: VALID_PHONE_REGEX },
            allow_blank: true
  validates :dock_group, company_id: true

  scope :active, -> {
    where("status != ? AND status != ?", "checked_out", "voided")
  }
  scope :include_docks, -> { includes(:dock) }

  def self.where_company_and_group(current_company_id, group_id)
    where("company_id = ? AND dock_group_id = ?", current_company_id, group_id)
  end

  def total_time
    if status_checked_out?
      end_time = checked_out_at
    elsif status_voided?
      end_time = voided_at
    else
      end_time = DateTime.now
    end
    distance_of_time_in_words(
      created_at.beginning_of_minute,
      end_time.beginning_of_minute
    )
  end

  def dock_number_if_assigned
    if dock_id.present?
      dock.number
    end
  end

  def status_human_readable
    human_attribute_name("status." + status)
  end

  private

    def clean_phone_number
      if phone_number.present?
        self.phone_number = StringUtil.digits_only(phone_number)
      end
    end

end
