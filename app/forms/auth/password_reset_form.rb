class Auth::PasswordResetForm < BaseForm

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :password_repeat?
  validate :user_valid?

  delegate :password, :password_confirmation, to: :@user

  def self.model_name
    ActiveModel::Name.new(self, nil, "Auth::PasswordReset")
  end

  def initialize(user)
    @user = user
    @user.current_user = user
  end

  def submit(params)
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if valid?
      @user.password_reset = false
      @user.save!
      true
    else
      false
    end
  end

  def password_repeat?
    if BCrypt::Password.new(@user.password_digest_was) == password
      errors.add(:password, I18n.t("form.errors.same"))
    end
  end

  def user_valid?
    unless @user.valid?
      errors.merge!(@user.errors)
    end
  end

end
