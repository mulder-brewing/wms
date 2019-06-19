class DockRequest < ApplicationRecord
  attr_accessor :save_success
  attr_accessor :current_user
  attr_accessor :context

  belongs_to :company
  belongs_to :dock_request_group

  validates :primary_reference, presence: true
  validates :dock, presence: true, if: :context_dock_assignment?
  validate :company_check, if: :current_user_is_set

  after_save :update_save_boolean

  def self.where_company_and_group(current_company_id, group)
    where("company_id = ? AND dock_request_group_id = ?", current_company_id, group)
  end

  private
    def update_save_boolean
      self.save_success = true
    end

    def current_user_is_set
      !current_user.nil?
    end

    def context_dock_assignment?
      context == "dock_assignment"
    end

    def company_check
      if company_id != current_user.company_id
        errors.add(:company_id, "doesn't match your company")
      end
    end
end
