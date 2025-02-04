class AccessPoliciesController < ApplicationController
  include FormHelper, ModalHelper, PageHelper, TableHelper

  def new
    form = new_form_prep_record(AccessPolicyForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
    render_modal(modal)
  end

  def create
    form = new_form_prep_record(AccessPolicyForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::CreateModal.new(form, table: form.table)
    render_modal(modal)
  end

  def edit
    form = new_form_prep_record(AccessPolicyForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(AccessPolicyForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, table: form.table)
    render_modal(modal)
  end

  def index
    page = prep_new_page(Page::IndexListPage)
    table = new_table_prep_records(Table::AccessPoliciesIndexTable)
    authorize_scope_records(table)
    page.table = table
    pagy_records(page)
    render_page(page)
  end

  def company
    authorize AccessPolicy
    if params[:company].present?
      access_policies = AccessPolicy.enabled_where_company(params[:company])
                                    .order(:description)
    else
      access_policies = AccessPolicy.none
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: { access_policies: access_policies }
        }
      end
    end
  end

  private

    def assign_form_attributes(form)
      form.attributes = params.require(form.record_name).permit(form.permitted_params)
    end

end
