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
    form.submit
    modal = Modal::VoidModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

end
