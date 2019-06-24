class DockGroup < ApplicationRecord
  belongs_to :company
  has_many :dock_requests, dependent: :destroy

  validates :description, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :description, scope: :company_id

  def self.where_company(company_id)
    where("company_id = ?", company_id)
  end

end
