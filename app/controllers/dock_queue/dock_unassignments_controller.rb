class DockQueue::DockUnassignmentsController < ApplicationController
  include FormHelper, ModalHelper

  def update
    form = new_form_prep_record(DockQueue::UnassignDockForm)
    authorize form.record
    modal = Modal::UpdateModal.new(form, table: form.table)
    form.status_fresh_check(modal)
    form.submit unless modal.error?
    render_modal(modal)
  end

end
