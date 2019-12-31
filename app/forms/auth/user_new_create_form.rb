class Auth::UserNewCreateForm < Auth::UserForm
  include Concerns::Email

  validates :password_confirmation, presence: true
  validate :email_exists_if_send_email

  attr_accessor :send_email

  delegate :password, :password_confirmation, to: :@user

  def prep_record(*)
    @user = Auth::User.new
  end

  def submit(params)
    @user.attributes = params
    @user.company_id ||= current_company_id
    if valid?
      @user.save!
      @save_success = true
    else
      @save_success = false
    end
  end

  def view_path
    super(self.class.superclass)
  end

  private

  def email_exists_if_send_email
    unless send_email_possible?(@user.email, @send_email)
      errors.add(:email, I18n.t("form.errors.email.blank"))
      errors.add(:send_email, I18n.t("form.errors.email.send.email_blank"))
    end
  end

end
