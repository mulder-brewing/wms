class LocationsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper, TableHelper

  def new
    form = new_form_prep_record(LocationForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
    render_modal(modal)
  end

  def create
    form = new_form_prep_record(LocationForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::CreateModal.new(form, table: form.table)
    render_modal(modal)
  end

  def edit
    form = new_form_prep_record(LocationForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(LocationForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, table: form.table)
    render_modal(modal)
  end

  def index
    page = prep_new_page(Page::IndexListPage)
    table = new_table_prep_records(Table::LocationsIndexTable)
    authorize_scope_records(table)
    page.table = table
    pagy_records(page)
    render_page(page)
  end

end
