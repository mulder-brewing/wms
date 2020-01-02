class Auth::UsersController < Auth::BaseController
    include FormHelper, ModalHelper

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
      index_page
    end

    private

    def assign_form_attributes(form)
      form.attributes = params.require(form.record_name).permit(form.permitted_params)
    end

    def index_page(page = nil)
      page = Page::IndexListPage.new if page.nil?

      records = page.records

      # If the page doesn't have records set already, use this default.
      records ||= controller_model.all

      authorize records
      records = policy_scope(records)

      if page.show_enabled_filter?
        enabled = ActiveRecord::Type::Boolean.new.deserialize(params[:enabled])
        records = records.where_enabled(enabled) unless enabled.nil?
        page.enabled_param = enabled
      end

      # Can be used to run commands on the records, like further filtering or
      # ordering the results.
      records = Array(recordsSendArray) \
        .inject(records) { |o, a| o.send(*a) } \
        if self.respond_to?(:recordsSendArray, true)

      pagy, records = pagy(records, items:25)

      page.records = records
      page.new_record = controller_model.new
      page.table = Table::Auth::UsersIndexTable.new(current_user)

      respond_to do |format|
        format.html {
          render  :template => page.index_html_path,
                  :locals => {  page: page,
                                pagy: pagy
                  }
        }
      end
    end

end
