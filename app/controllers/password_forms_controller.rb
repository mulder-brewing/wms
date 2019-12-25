class PasswordFormsController < ApplicationController
  skip_before_action :check_reset_password

  def new
    form = authorize PasswordForm.new(current_user)
    render :locals => { form: form }
  end

  def create
    form = authorize PasswordForm.new(current_user)
    if form.submit(params[:password_form])
      flash[:success] = t("alert.save.password_success")
      all_formats_redirect_to(root_url)
    else
      render "new", :locals => { form: form }
    end
  end

end
