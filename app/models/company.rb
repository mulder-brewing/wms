class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :dock_groups, dependent: :destroy
  has_many :dock_requests, through: :dock_groups

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  before_validation :strip_whitespace

  private
    def strip_whitespace
      self.name.strip! if !name.nil?
    end
end
