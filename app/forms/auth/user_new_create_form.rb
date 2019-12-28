class Auth::UserNewCreateForm < BaseForm
  include Concerns::Auth::SendEmail
  include Concerns::Auth::ValidateUser

  validates :password_confirmation, presence: true
  validate :email_exists_if_send_email
  validate :user_valid

  attr_accessor :user, :send_email

  delegate  :company_id, :company_id=,
            :first_name, :first_name=,
            :last_name, :last_name=,
            :email, :email=,
            :username, :username=,
            :password, :password=,
            :password_confirmation, :password_confirmation=,
            :company_admin, :company_admin=,
            :access_policy_id, :access_policy_id=,
            :table_row_id,
            to: :@user

  def initialize(params = nil)
    @user = Auth::User.new
    super
  end

  def submit
    @user.current_user = current_user
    if valid?
      @user.save!
      @save_success = true
    else
      @save_success = false
    end
  end

  def record
    @user
  end

end
