class AccessPolicy < ApplicationRecord
  belongs_to :company
  has_many :users

  validates :description, presence: true

end
