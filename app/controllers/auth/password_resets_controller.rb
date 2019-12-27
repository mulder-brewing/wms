class Auth::PasswordResetsController < Auth::BaseController

  skip_before_action :check_reset_password
  before_action :skip_authorization
  before_action :skip_policy_scope

  def new
    form = Auth::PasswordResetForm.new(current_user)
    render :locals => { form: form }
  end

  def create
    form = Auth::PasswordResetForm.new(current_user)
    if form.submit(params[:auth_password_reset])
      flash[:success] = t("alert.save.password_success")
      all_formats_redirect_to(root_url)
    else
      render "new", :locals => { form: form }
    end
  end

end
