class Auth::PasswordUpdateFormsController < Auth::BaseController
  include GenericModalFormPageHelper

  def edit
    edit_modal
  end

  def update
    # user = find_object_with_current_user(Auth::User)
    # form = Auth::PasswordUpdateForm.new(user)
    # puts form.record_name
    update_record
  end

  private
    def record_params
      params.require(:auth_password_update_form).permit(:password, :password_confirmation, :send_email)
    end

    def modal_form_callback(modal_form, action)
      case action
      when :edit, :update
        modal_form.modal.title = "auth/users.security.reset_password"
        modal_form.form.show_timestamps = false
      end
      return modal_form
    end

end
