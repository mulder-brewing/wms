class ShipperProfile < ApplicationRecord
  belongs_to :company
  belongs_to :shipper, class_name: "Company"

  validates_uniqueness_of :shipper_id, scope: :company_id

  def self.where_enabled(enabled)
    where("shipper_profiles.enabled = ?", enabled)
  end

  def self.includes_shipper
    includes(:shipper)
  end
end
