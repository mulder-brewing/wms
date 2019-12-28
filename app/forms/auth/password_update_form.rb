class Auth::PasswordUpdateForm < BaseForm
  include Concerns::Auth::SendEmail
  include Concerns::Auth::ValidateUser

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :email_exists_if_send_email
  validate :not_self_if_send_email
  validate :user_valid

  attr_accessor :user, :send_email

  delegate  :password, :password=,
            :password_confirmation, :password_confirmation=,
            :email, :email=,
            to: :@user

  def persisted?
    @user.persisted?
  end

  def id
    @user.id
  end

  def initialize(params = nil)
    super
    @user = find_object_with_current_user(Auth::User, @id) unless @id.nil?
  end

  def submit(params = nil)
    @user.password_reset = true unless self?(@user)
    if valid?
      ActiveRecord::Base.transaction do
        @user.save!
        send_user_mail(:password_reset) if send_email?
        @save_success = true
      end    
    end
  rescue
    @save_success = false
  end
  end

  def record
    @user
  end

  private

  def not_self_if_send_email
    if send_email? && self?(@user)
      errors.add(:send_email, I18n.t("form.errors.email.send.self"))
    end
  end

end
