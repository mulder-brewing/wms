class User < ApplicationRecord
  attr_accessor :current_user
  attr_accessor :context_password_reset
  attr_accessor :send_email
  attr_accessor :send_what_email

  belongs_to :company

  before_validation :strip_whitespace
  validates :current_user, presence: true
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
  validate :company_check, if: :current_user_pre_check
  validate :regular_user_check, if: :current_user_pre_check
  validate :self_disable_check, if: :current_user_pre_check
  validate :self_unadmin_check, if: :current_user_pre_check
  validate :password_repeat?

  before_save :check_password_digest, if: :current_user_pre_check

  after_create_commit :send_welcome_email

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

  def User.password_requirements
    '8-64 characters, no spaces, with at least one of each: uppercase, lowercase, number, special'
  end

  private
    def strip_whitespace
      self.first_name.strip! if self.first_name?
      self.last_name.strip! if self.last_name?
      self.email.strip! if self.email?
    end

    # Returns the hash digest of the given string, used for user fixtures with minitest.
    def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # check that the current user's company matches the company of this instance
    def company_check
      if company_id != current_user.company_id
        errors.add(:company_id, "doesn't match your company") unless current_user.app_admin
      end
    end

    def regular_user_check
      if !current_user.company_admin && !current_user.app_admin
        #you are a regular user
        errors.add(:base, "can't edit users other than yourself") if !self_equals_current_user?
      end
    end

    def self_disable_check
      if self_equals_current_user? && enabled_changed?
        #are you trying to disable yourself?
        errors.add(:enabled, "cannot be disabled for yourself") if enabled == false
      end
    end

    def self_unadmin_check
      if self_equals_current_user? && company_admin_changed?
        #are you trying to unadmin yourself?
        errors.add(:company_admin, "cannot be disabled for yourself") if company_admin == false
      end
    end

    def current_user_is_set
      !current_user.nil?
    end

    def current_user_not_seed
      current_user != "seed"
    end

    def current_user_pre_check
      current_user_is_set && current_user_not_seed
    end

    def check_password_digest
      if password_digest_changed?
        if password_reset == true && self_equals_current_user?
          self.password_reset = false
        elsif password_reset == false && !self_equals_current_user?
          self.password_reset = true
        end
      end
    end

    def self_equals_current_user?
      self == current_user
    end

    def password_repeat?
      if context_password_reset == true && BCrypt::Password.new(password_digest_was) == password
        errors.add(:password, "cannot be the same as it is right now")
      end
    end

    def send_welcome_email
      if send_what_email == "create" && send_email && !email.nil? 
        UserMailer.create_user(self).deliver_now
      end
    end


end
