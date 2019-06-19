class DockRequestGroup < ApplicationRecord
  has_many :dock_requests, dependent: :destroy

  attr_accessor :save_success
  attr_accessor :current_user

  after_save :update_save_boolean

  validates :description, presence: true, length: { maximum: 50 }
  validates :company_id, presence: true
  validates_uniqueness_of :description, scope: :company_id

  def self.where_company(company_id)
    where("company_id = ?", company_id)
  end

  private
  def update_save_boolean
    self.save_success = true
  end
end
