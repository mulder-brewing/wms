class User < ApplicationRecord

  belongs_to :company

  before_validation :strip_whitespace
  validates :company_id, presence: true
  # Regex for lowercase letters, numbers, and underscore.
  VALID_USERNAME_REGEX = /\A[a-z0-9_]*\z/
  validates :username, presence: true, length: { maximum: 50 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # Regex for 8-64 characters, must have at least one uppercase, lowercase, number, and special character.  No spaces
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d.*)(?=.*\W.*)[a-zA-Z0-9\S]{8,64}\z/
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }, allow_blank: true, allow_nil: true

  validate :self_admin_enabled, on: :self
  validate :self_enabled, on: :self

  has_secure_password

  def enabled_yes_no?
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

  # Scope for excluding user from all users.
  def self.all_except(user)
    where.not(id: user)
  end

  def self.where_company_users_except(user)
    where("id != ? AND company_id = ?", user.id, user.company_id)
  end

  private
    def strip_whitespace
      self.first_name.strip! if self.first_name?
      self.last_name.strip! if self.last_name?
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

    # Returns the hash digest of the given string, used for user fixtures with minitest.
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

end
