class Company < ApplicationRecord
  has_many :users, class_name: "Auth::User", dependent: :destroy
  has_many :dock_groups, dependent: :destroy
  has_many :docks, dependent: :destroy
  has_many :dock_requests, class_name: "DockQueue::DockRequest", dependent: :destroy
  has_many :dock_request_audit_histories, class_name: "DockQueue::DockRequestAuditHistory", dependent: :destroy
  has_many :access_policies, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  before_validation :strip_whitespace

  after_create_commit :create_defaults

  private
    def strip_whitespace
      self.name.strip! if !name.nil?
    end

    def create_defaults
      DockGroup.create(description: "Default", company_id: id)
      AccessPolicy.create(description: "Everything", company_id: id, everything: true)
    end
end
