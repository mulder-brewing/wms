class DockGroupsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

  def new
    form = new_form_prep_record(DockGroupForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
    render_modal(modal)
  end

  def create
    form = new_form_prep_record(DockGroupForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::CreateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def edit
    form = new_form_prep_record(DockGroupForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(DockGroupForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def index
    page = new_page_prep_records(Page::IndexListPage)
    page.table = Table::DockGroupsIndexTable.new(current_user)
    authorize_scope_records(page)
    pagy_records(page)
    render_page(page)
  end

end
