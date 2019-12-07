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
    respond_to do |format|
      format.js {
        render  :template => modal_form.save_result_js_path,
                :locals => { modal_form: modal_form }
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
    respond_to do |format|
      format.js {
        render  :template => modal_form.save_result_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def index
    @pagy, @records = pagy(AccessPolicy.where_company(current_company_id).order(:description), items:25)
    @GenericPage = Page::GenericPage.new(:index, @records)
  end

  private
    def record_params
      params.require(:access_policy).permit(:description, :enabled)
    end

    def find_record
      find_object_redirect_invalid(controller_name.classify.constantize)
    end
end
