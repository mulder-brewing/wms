class PasswordForm
  include ActiveModel::Model

  attr_accessor :password, :password_confirmation

  validate :password_repeat?

  def initialize(user)
    @user = user
    @user.current_user = user
  end

  def submit(params)
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    if valid?
      @user.password = @password
      @user.password_confirmation = @password_confirmation
      @user.password_reset = false
      begin
        @user.save!
      rescue ActiveRecord::RecordInvalid
        errors.merge!(@user.errors)
        return false
      end
      true
    else
      false
    end
  end

  def password_repeat?
    if BCrypt::Password.new(@user.password_digest) == @password
      errors.add(:password, I18n.t("form.errors.same"))
    end
  end

end
