class AccessPolicy < ApplicationRecord
  belongs_to :company
  has_many :users

  validates :description, presence: true, length: { maximum: NORMAL_LENGTH }
  validates_uniqueness_of :description, scope: :company_id, case_sensitive: false

  def check(permission)
    return false if permission.nil? || !self[:enabled]
    self[:everything] || self[permission]
  end

  def description=(val)
    super(val&.strip)
  end

end
