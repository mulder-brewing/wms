class CompaniesController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

  def new
    form = new_form_prep_record(CompanyForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
    render_modal(modal)
  end

  def create
    form = new_form_prep_record(CompanyForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::CreateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def edit
    form = new_form_prep_record(CompanyForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(CompanyForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def index
    page = new_page_prep_records(Page::IndexListPage)
    page.table = Table::CompaniesIndexTable.new(current_user)
    authorize_scope_records(page)
    pagy_records(page)
    render_page(page)
  end

  def destroy_modal
    form = new_form_prep_record(DestroyRecordForm)
    authorize form.record
    modal = Modal::DestroyModal.new(form)
    modal.chicken_msg_target = form.record.name
    render_modal(modal)
  end

  def destroy
    form = new_form_prep_record(DestroyRecordForm)
    authorize form.record
    modal = Modal::DestroyModal.new(form)
    form.submit(modal)
    modal.table = Table::CompaniesIndexTable.new(current_user)
    render_modal(modal)
  end

end
