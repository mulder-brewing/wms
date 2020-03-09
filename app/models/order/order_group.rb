class Order::OrderGroup < ApplicationRecord
  belongs_to :company

  validates :description, presence: true, length: { maximum: NORMAL_LENGTH }
  validates_uniqueness_of :description, scope: :company_id, case_sensitive: false

  def description=(val)
    super(val&.strip)
  end
  
end
