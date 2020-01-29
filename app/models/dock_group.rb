class DockGroup < ApplicationRecord
  belongs_to :company
  has_many :dock_requests, class_name: "DockQueue::DockRequest", dependent: :destroy
  has_many :docks, dependent: :destroy

  validates :description, presence: true, length: { maximum: NORMAL_LENGTH }
  validates_uniqueness_of :description, scope: :company_id

end
