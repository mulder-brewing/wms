class Auth::UserNewCreateForm < Auth::UserForm
  include Concerns::Email

  validates :password_confirmation, presence: true
  validate :email_exists_if_send_email

  attr_accessor :send_email

  delegate  :password, :password=,
            :password_confirmation, :password_confirmation=,
            to: :@record

  def view_path
    super(self.class.superclass)
  end

  def permitted_params
    permitted = [:first_name, :last_name, :username, :company_admin,
        :access_policy_id, :password, :password_confirmation,
        :email, :send_email]
    permitted << :company_id if app_admin?
    return permitted
  end

  def setup_variables
    super
    if app_admin? && controller.action_name == "new"
      @access_policies = AccessPolicy.none
    end
  end

  private

  def email_exists_if_send_email
    unless send_email_possible?(@record.email, @send_email)
      errors.add(:email, I18n.t("form.errors.email.blank"))
      errors.add(:send_email, I18n.t("form.errors.email.send.email_blank"))
    end
  end

end
