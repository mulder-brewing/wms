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
    modal = Modal::CreateModal.new(form, table: form.table)
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
    modal = Modal::UpdateModal.new(form, table: form.table)
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
    form.to_delete = form.record.name
    authorize form.record
    modal = Modal::DestroyModal.new(form)
    render_modal(modal)
  end

  def destroy
    form = new_form_prep_record(DestroyRecordForm)
    form.to_delete = form.record.name
    authorize form.record
    form.submit
    modal = Modal::DestroyModal.new(form)
    modal.table = Table::CompaniesIndexTable.new(current_user)
    render_modal(modal)
  end

  private

  def assign_form_attributes(form)
    form.attributes = params.require(form.record_name).permit(form.permitted_params)
  end

end
