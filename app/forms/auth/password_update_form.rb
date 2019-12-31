class Auth::PasswordUpdateForm < RecordForm
  include Concerns::Email

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :user_valid
  validate :email_exists_if_send_email
  validate :not_self_if_send_email

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
      @user.save!
      send_email if send_email?
      @save_success = true
    else
      @save_success = false
    end
  end

  def record
    @user
  end

  private

  def user_valid
    unless @user.valid?
      errors.merge!(@user.errors)
    end
  end

  def send_email
    UserMailer.password_reset(@user).deliver_now
  end

  def send_email?
    @send_email_bool = ActiveModel::Type::Boolean.new.cast(@send_email)
  end

  def email_exists_if_send_email
    unless send_email_possible?(@user.email, @send_email)
      errors.add(:email, I18n.t("form.errors.email.blank"))
      errors.add(:send_email, I18n.t("form.errors.email.send.email_blank"))
    end
  end

  def not_self_if_send_email
    if send_email? && self?(@user)
      errors.add(:send_email, I18n.t("form.errors.email.send.self"))
    end
  end

end
