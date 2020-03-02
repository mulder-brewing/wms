class DockQueue::VoidDockRequestsController < ApplicationController
  include FormHelper, ModalHelper

  def edit
    form = new_form_prep_record(DockQueue::VoidDockRequestForm)
    authorize form.record
    modal = Modal::VoidModal.new(form)
    form.status_fresh_check(modal)
    modal.chicken_msg_target = form.record.primary_reference
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(DockQueue::VoidDockRequestForm)
    authorize form.record
    modal = Modal::VoidModal.new(form, table: form.table)
    form.status_fresh_check(modal)
    form.submit unless modal.error?
    render_modal(modal)
  end

end
