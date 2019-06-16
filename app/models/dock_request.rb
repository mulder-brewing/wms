class DockRequest < ApplicationRecord
  attr_accessor :save_success

  belongs_to :company

  after_save :update_save_boolean

  def self.where_status_not_checked_out(current_company_id)
    where("company_id = ? AND status != ?", current_company_id, "Checked Out")
  end

  private
    def update_save_boolean
      self.save_success = true
    end


end
