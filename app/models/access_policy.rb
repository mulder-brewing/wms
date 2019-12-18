class AccessPolicy < ApplicationRecord
  belongs_to :company
  has_many :users

  validates :description, presence: true

  def check(permission)
    return false if permission.nil? || !self[:enabled]
    self[:everything] || self[permission]
  end

end
