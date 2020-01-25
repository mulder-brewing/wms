class DockQueue::DockAssignmentsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

  def edit
    form = new_form_prep_record(DockQueue::AssignDockForm)
    authorize form.record
    modal = Modal::EditModal.new(form, page: form.page, table: form.table)
    form.error_check_modal(modal)
    unless modal.error?
      form.setup_variables
      modal.footer.show_timestamps = false
      modal.title = "dock_queue/dock_assignments.assign_dock"
    end
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(DockQueue::AssignDockForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    form.setup_variables
    modal = Modal::UpdateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def destroy
    form = new_form_prep_record(DockQueue::UnassignDockForm)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

end
