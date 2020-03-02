class Auth::PasswordUpdatesController < ApplicationController
  include FormHelper, ModalHelper
  include Auth::PasswordUpdatesHelper

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

    def customize_modal(modal)
      modal.title = password_update_title(modal.form.record)
      modal.footer.show_timestamps = false
    end

end
