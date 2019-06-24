class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  attr_accessor :current_user
  attr_accessor :save_success

  validate :company_check, if: :current_user_pre_check

  after_save :update_save_boolean

  private
    # check that the current user's company matches the company of this instance
    def company_check
      if company_id != current_user.company_id
        errors.add(:company_id, "doesn't match your company")
      end
    end

    # This helps in knowing whether save was successful in the controller, JS, or views.
    def update_save_boolean
      self.save_success = true
    end

    # Current user functions
    def current_user_is_set
      !current_user.nil?
    end

    def current_user_not_seed
      current_user != "seed"
    end

    def current_user_pre_check
      current_user_is_set && current_user_not_seed
    end
end
