class DockRequest < ApplicationRecord
  enum status: { checked_in: "checked_in", dock_assigned: "dock_assigned", checked_out: "checked_out" }, _prefix: :status

  attr_accessor :context

  belongs_to :dock_group
  belongs_to :dock, optional: true

  before_validation :clean_phone_number

  validates :primary_reference, presence: true
  validates :dock_id, presence: true, if: :context_dock_assignment?
  VALID_PHONE_REGEX = /\A\d{10}\z/
  validates :phone_number, length: { is: 10 }, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validate :phone_number_if_text_message

  scope :active, -> { where("status != ?", "checked_out") }

  after_update_commit :send_sms, if: :context_dock_assignment?

  def self.where_company_and_group(current_company_id, group_id)
    where("company_id = ? AND dock_group_id = ?", current_company_id, group_id)
  end

  private
    def context_dock_assignment?
      context == "dock_assignment"
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
end
