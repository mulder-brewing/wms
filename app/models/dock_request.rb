class DockRequest < ApplicationRecord
  attr_accessor :save_success
  attr_accessor :current_user

  belongs_to :company

  validates :primary_reference, presence: true
  validate :company_check, if: :current_user_is_set

  after_save :update_save_boolean

  def self.where_status_not_checked_out(current_company_id)
    where("company_id = ? AND status != ?", current_company_id, "Checked Out")
  end

  private
    def update_save_boolean
      self.save_success = true
    end

    def current_user_is_set
      !current_user.nil?
    end

    def company_check
      if company_id != current_user.company_id
        errors.add(:company_id, "doesn't match your company")
      end
    end
end
