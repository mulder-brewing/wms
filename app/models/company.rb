class Company < ApplicationRecord
  enum company_type: {
    admin: "admin",
    warehouse: "warehouse",
    shipper: "shipper",
  }, _prefix: :type

  has_many :users, class_name: "Auth::User", dependent: :destroy
  has_many :dock_groups, dependent: :destroy
  has_many :docks, dependent: :destroy
  has_many :dock_requests, class_name: "DockQueue::DockRequest", dependent: :destroy
  has_many :dock_request_audit_histories, class_name: "DockQueue::DockRequestAuditHistory", dependent: :destroy
  has_many :access_policies, dependent: :destroy
  has_many :order_groups, class_name: "Order::OrderGroup", dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :company_type, presence: true

  def type_human_readable
    return "" if company_type.nil?
    human_attribute_name("company_type." + company_type)
  end

  def name=(val)
    super(val&.strip)
  end

end
