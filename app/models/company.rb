class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :dock_groups, dependent: :destroy
  has_many :docks, dependent: :destroy
  has_many :dock_requests, dependent: :destroy
  has_many :dock_request_audit_histories, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  before_validation :strip_whitespace

  after_create_commit :create_defaults

  private
    def strip_whitespace
      self.name.strip! if !name.nil?
    end

    def create_defaults
      DockGroup.create(description: "Default", company_id: id)
    end
end
