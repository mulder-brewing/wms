class Company < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  before_save :strip_whitespace

  private

    def strip_whitespace
      self.name.strip!
    end
end
