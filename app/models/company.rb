class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :dock_requests, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  before_validation :strip_whitespace

  def enabled_yes_no
    if self.enabled
      "Yes"
    else
      "No"
    end
  end

  private
    def strip_whitespace
      self.name.strip! if !name.nil?
    end
end
