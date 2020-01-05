class Auth::PasswordResetsController < ApplicationController
  include FormHelper

  skip_before_action :check_reset_password

  def edit
    form = new_form_prep_record(Auth::PasswordResetForm)
    authorize form
    render :locals => { form: form }
  end

  def update
    form = new_form_prep_record(Auth::PasswordResetForm)
    assign_form_attributes(form)
    authorize form
    form.submit
    if form.submit_success
      flash[:success] = t("alert.save.password_success")
      all_formats_redirect_to(root_url)
    else
      render "edit", :locals => { form: form }
    end
  end

  private

  def assign_form_attributes(form)
    form.attributes = params.require(form.record_name)
      .permit(:password, :password_confirmation)
  end

end
