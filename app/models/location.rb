class Location < ApplicationRecord
  belongs_to :company

  validates :ref,
            presence: true,
            length: { maximum: NORMAL_LENGTH },
            uniqueness: { scope: :company_id, case_sensitive: false }
  validates :name, presence: true
  validates :address_1, presence: true
  validates :city, presence: true
  validates :state, presence: true, length: { maximum: 3 }
  validates :postal_code, presence: true, zipcode: { country_code_attribute: :country }
  validates :country, presence: true, length: { maximum: 2 }
  validate :country_valid
  validate :state_valid

  def ref=(val)
    super(val&.strip)
  end

  def name=(val)
    super(val&.strip)
  end

  def address_1=(val)
    super(val&.strip)
  end

  def address_2=(val)
    super(val&.strip)
  end

  def city=(val)
    super(val&.strip)
  end

  def state=(val)
    super(val&.strip)
  end

  def postal_code=(val)
    super(val&.strip)
  end

  def country=(val)
    super(val&.strip)
  end

  private

  def country_valid
    unless GeographyUtil.country_valid?(country)
      errors.add(:country)
    end
  end

  def state_valid
    unless GeographyUtil.state_valid?(country, state)
      errors.add(:state)
    end
  end


end
