class Auth::UsersController < Auth::BaseController
    include FormHelper, ModalHelper, PageHelper

    def new
      form = new_form_prep_record(Auth::UserNewCreateForm)
      authorize form.record
      form.setup_variables
      modal = Modal::NewModal.new(form)
      render_modal(modal)
    end

    def create
      form = new_form_prep_record(Auth::UserNewCreateForm)
      assign_form_attributes(form)
      authorize form.record
      form.submit
      form.setup_variables
      modal = Modal::CreateModal.new(form, table: form.table)
      render_modal(modal)
    end

    def edit
      form = new_form_prep_record(Auth::UserEditUpdateForm)
      authorize form.record
      form.setup_variables
      modal = Modal::EditModal.new(form)
      render_modal(modal)
    end

    def update
      form = new_form_prep_record(Auth::UserEditUpdateForm)
      assign_form_attributes(form)
      authorize form.record
      form.submit
      form.setup_variables
      modal = Modal::UpdateModal.new(form, table: form.table)
      render_modal(modal)
    end

    def index
      page = Page::IndexListPage.new(self)
      page.table = Table::Auth::UsersIndexTable.new(current_user)
      records = page.prep_records(params)
      authorize records
      records = policy_scope(records)
      pagy, page.records = pagy(records, items:25)
      render_page(page, pagy)
    end

    private

    def assign_form_attributes(form)
      form.attributes = params.require(form.record_name).permit(form.permitted_params)
    end

end
