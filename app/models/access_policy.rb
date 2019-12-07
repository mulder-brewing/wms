class AccessPolicy < ApplicationRecord
  belongs_to :company

  validates :description, presence: true

end
