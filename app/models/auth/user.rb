class Auth::User < ApplicationRecord
  attr_accessor :send_email
  attr_accessor :send_what_email

  belongs_to :company
  belongs_to :access_policy
  has_many :dock_request_audit_histories, dependent: :destroy

  before_validation :strip_whitespace
  validates :company_id, presence: true
  validates :access_policy_id, presence: true
  # Regex for lowercase letters, numbers, and underscore.
  VALID_USERNAME_REGEX = /\A[a-z0-9_]*\z/
  validates :username, presence: true, length: { maximum: 50 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # Regex for 8-64 characters, must have at least one uppercase, lowercase, number, and special character.  No spaces
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d.*)(?=.*\W.*)[a-zA-Z0-9\S]{8,64}\z/
  validates :password, format: { with: VALID_PASSWORD_REGEX }, allow_nil: true
  # validate :regular_user_check, if: :current_user_pre_check
  # validate :self_disable_check, if: :current_user_pre_check
  # validate :self_unadmin_check, if: :current_user_pre_check
  validate :access_policy_matches_user_company

  after_create_commit :send_welcome_email

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

    def self_equals_current_user?
      self == current_user
    end

    def regular_user_check
      if !current_user.company_admin && !current_user.app_admin
        #you are a regular user
        errors.add(:id, :mismatch) if !self_equals_current_user?
      end
    end

    def self_disable_check
      if self_equals_current_user? && enabled_changed?
        #are you trying to disable yourself?
        errors.add(:enabled,
          I18n.t("form.errors.disabled_self")) if enabled == false
      end
    end

    def self_unadmin_check
      if self_equals_current_user? && company_admin_changed?
        #are you trying to unadmin yourself?
        errors.add(:company_admin,
          I18n.t("form.errors.disabled_self")) if company_admin == false
      end
    end

    def send_mail?
      send_email == "1" && !email.blank?
    end

    def send_email_of_type?(type)
      send_what_email == type && send_mail?
    end

    def send_welcome_email
      if send_email_of_type?("create")
        UserMailer.create_user(self).deliver_now
      end
    end

    def change_after_commit?(attribute)
      self.previous_changes.has_key?(attribute)
    end

    def access_policy_matches_user_company
      if !self.access_policy.nil? && self.access_policy.company_id != self.company_id
        errors.add(:access_policy_id, I18n.t("form.errors.does_not_belong"))
      end
    end

end