class Auth::PasswordUpdateForm < BaseForm

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :user_valid?

  attr_accessor :user, :send_email
  attr_writer :email

  delegate  :password, :password=,
            :password_confirmation, :password_confirmation=,
            :email,
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
    if valid?
      @user.save!
      @save_success = true
    else
      puts self.password
      puts self.password_confirmation
      false
    end
  end

  def user_valid?
    unless @user.valid?
      errors.merge!(@user.errors)
    end
  end

end
