class DockGroup < ApplicationRecord
  belongs_to :company
  has_many :dock_requests, dependent: :destroy
  has_many :docks, dependent: :destroy

  validates :description, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :description, scope: :company_id

  scope :enabled, -> { where(enabled: true) }

  def self.enabled_where_company(current_company_id)
    where_company(current_company_id).enabled
  end

end
