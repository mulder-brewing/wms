class DockQueue::DockAssignmentsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

  def edit
    form = new_form_prep_record(DockQueue::DockAssignmentForm)
    authorize form.record
    form.setup_variables
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

end
