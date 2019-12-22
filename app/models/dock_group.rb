class DockGroup < ApplicationRecord
  belongs_to :company
  has_many :dock_requests, dependent: :destroy
  has_many :docks, dependent: :destroy

  validates :description, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :description, scope: :company_id

  def self.record_options(company_id, record_id)
    enabled_where_company(company_id).or(where(id: record_id))
  end

end
