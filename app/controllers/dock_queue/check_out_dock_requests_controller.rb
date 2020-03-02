class DockQueue::CheckOutDockRequestsController < ApplicationController
  include FormHelper, ModalHelper

  def edit
    form = new_form_prep_record(DockQueue::CheckOutDockRequestForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    form.status_fresh_check(modal)
    unless modal.error?
      modal.footer.show_timestamps = false
      modal.title = "dock_queue/check_out_dock_requests.title.check_out"
    end
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(DockQueue::CheckOutDockRequestForm)
    authorize form.record
    modal = Modal::UpdateModal.new(form, table: form.table)
    modal.save_result = Table::SaveResult::REMOVE
    form.status_fresh_check(modal)
    form.submit
    render_modal(modal)
  end
end
