class User < ApplicationRecord

  belongs_to :company

  before_validation :strip_whitespace
  validates :company_id, presence: true
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validate :self_admin_enabled, on: :self
  validate :self_enabled, on: :self
  # Regex for 8-64 characters, must have at least one uppercase, lowercase, number, and special character.
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d.*)(?=.*\W.*)[a-zA-Z0-9\S]{8,64}\z/
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_blank: true
  # Regex for lowercase letters, numbers, and underscore.
  VALID_USERNAME_REGEX = /\A[a-z0-9_]*\z/
  validates :username, format: { with: VALID_USERNAME_REGEX }


  has_secure_password

  def enabled?
    if self.enabled
      "Yes"
    else
      "No"
    end
  end

  def company_admin_yes_no?
    if self.company_admin
      "Yes"
    else
      "No"
    end
  end

  def full_name
    self.first_name + ' ' + self.last_name
  end

  private
    def strip_whitespace
      self.username.strip!
      self.first_name.strip!
      self.last_name.strip!
      self.email.strip! if self.email?
    end

    # Do not allow the current user to disable admin for themself.
    def self_admin_enabled
      if company_admin == false
        errors.add(:company_admin, "cannot be disabled for yourself")
      end
    end

    # Do not allow the current user to disable themself.
    def self_enabled
      if enabled == false
        errors.add(:enabled, "cannot be disabled for yourself")
      end
    end

end
