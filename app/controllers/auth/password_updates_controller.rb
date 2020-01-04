class Auth::PasswordUpdatesController < ApplicationController
  include FormHelper, ModalHelper

  def edit
    form = new_form_prep_record(Auth::PasswordUpdateForm)
    authorize form
    modal = Modal::EditModal.new(form)
    customize_modal(modal)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(Auth::PasswordUpdateForm)
    assign_form_attributes(form)
    authorize form
    form.submit
    modal = Modal::UpdateModal.new(form)
    customize_modal(modal)
    render_modal(modal)
  end

  private
    def assign_form_attributes(form)
      form.attributes = params.require(form.record_name)
        .permit(:password, :password_confirmation, :email, :send_email)
    end

    def customize_modal(modal)
      modal.title = "auth/users.security.reset_password"
      modal.footer.show_timestamps = false
    end

end