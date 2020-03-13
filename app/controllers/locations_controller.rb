class LocationsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper, TableHelper

  def new
    form = new_form_prep_record(LocationForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
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
