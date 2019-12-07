class AccessPoliciesController < ApplicationController
  before_action :skip_authorization
  before_action :logged_in_admin

  def new
    record = AccessPolicy.new
    modal_form = ModalForm::GenericModalForm.new(:create, record)
    respond_to do |format|
      format.js {
        render  :template => modal_form.generic_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def create
    record = AccessPolicy.new(record_params)
    record.update(:company_id => current_company_id)
    modal_form = ModalForm::GenericModalForm.new(:create, record)
    table = Table::GenericTable.new(table_array_hash)
    respond_to do |format|
      format.js {
        render  :template => modal_form.save_result_js_path,
                :locals => {  modal_form: modal_form,
                              table: table
                            }
      }
    end
  end

  def edit
    record = find_record
    modal_form = ModalForm::GenericModalForm.new(:update, record)
    respond_to do |format|
      format.js {
        render  :template => modal_form.generic_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def update
    record = find_record
    record.update(record_params) unless record.nil?
    modal_form = ModalForm::GenericModalForm.new(:update, record)
    table = Table::GenericTable.new(table_array_hash)
    respond_to do |format|
      format.js {
        render  :template => modal_form.save_result_js_path,
                :locals => {  modal_form: modal_form,
                              table: table
                            }
      }
    end
  end

  def index
    pagy, records = pagy(AccessPolicy.where_company(current_company_id).order(:description), items:25)
    page = Page::GenericPage.new(:index, records)
    page.add_table(table_array_hash)

    respond_to do |format|
      format.html {
        render  :template => page.index_html_path,
                :locals => {  page: page,
                              pagy: pagy
                }
      }
    end
  end

  private
    def record_params
      params.require(:access_policy).permit(:description, :enabled, :everything, :dock_groups, :docks)
    end

    def table_array_hash
      [
        { name: :actions, edit_button: true },
        { name: :description },
        { name: :enabled, text_key_qualifier: :enabled }
      ]
    end
end
