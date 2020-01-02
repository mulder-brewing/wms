class Auth::UserEditUpdateForm < Auth::UserForm

  delegate  :enabled, :enabled=, to: :@record

  def initialize(*)
    super
    @view_class = self.class.superclass
  end

  def permitted_params
    permitted = [:email]
    if admin?
      permitted.push(:first_name, :last_name, :username, :company_admin,
        :access_policy_id, :enabled)
      permitted << :company_id if app_admin?
    end
    return permitted
  end

end
