class Auth::User < ApplicationRecord

  belongs_to :company
  belongs_to :access_policy
  has_many :dock_request_audit_histories, class_name: "DockQueue::DockRequestAuditHistory", dependent: :destroy

  before_validation :strip_whitespace
  validates :company_id, presence: true
  validates :access_policy_id, presence: true
  # Regex for lowercase letters, numbers, and underscore.
  VALID_USERNAME_REGEX = /\A[a-z0-9_]*\z/
  validates :username, presence: true, length: { maximum: NORMAL_LENGTH }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: NORMAL_LENGTH }
  validates :last_name, presence: true, length: { maximum: NORMAL_LENGTH }
  validates :email, length: { maximum: EMAIL_LENGTH }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # Regex for 8-64 characters, must have at least one uppercase, lowercase, number, and special character.  No spaces
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d.*)(?=.*\W.*)[a-zA-Z0-9\S]{8,64}\z/
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
  validates :access_policy, company_id: true

  has_secure_password

  def full_name
    self.first_name + ' ' + self.last_name
  end

  def full_name_username
    full_name + " (#{self.username})"
  end

  # Scope for excluding user from all users.
  def self.all_except(user)
    where.not(id: user)
  end

  def self.where_company_users_except(user)
    where("id != ? AND company_id = ?", user.id, user.company_id)
  end

  def self.includes_company
    includes(:company)
  end

  private
    def strip_whitespace
      self.first_name.strip! if self.first_name?
      self.last_name.strip! if self.last_name?
      self.email.strip! if self.email?
    end

    # Returns the hash digest of the given string, used for user fixtures with minitest.
    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

end
