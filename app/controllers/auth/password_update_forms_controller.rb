class Auth::PasswordUpdateFormsController < Auth::BaseController
  include GenericModalFormPageHelper

  def edit
    edit_modal
  end

  def update
    update_record
  end

  private
    def record_params
      params.require(controller_model.record_name)
        .permit(:password, :password_confirmation, :email, :send_email)
    end

    def modal_form_callback(modal_form)
      modal_form.modal.title = "auth/users.security.reset_password"
      modal_form.form.show_timestamps = false
    end

end
