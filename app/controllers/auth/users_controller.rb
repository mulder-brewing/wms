class Auth::UsersController < Auth::BaseController
    include ModalHelper

    def new
      modal = new_modal(Auth::UserNewCreateForm)
      setup_form_variables(modal.form.record)
      render_modal(modal)
    end

    def create
      modal = new_modal(Auth::UserNewCreateForm)
      modal.form.submit(record_params)
      setup_form_variables(modal.form.record)
      render_modal(modal)
    end

    def edit
      modal = new_modal(Auth::UserEditUpdateForm)
      setup_form_variables(modal.form.record)
      render_modal(modal)
    end

    def update
      modal = new_modal(Auth::UserEditUpdateForm)
      modal.form.submit(record_params)
      setup_form_variables(modal.form.record)
      render_modal(modal)
    end

    def index
      index_page
    end

    private

    def record_params
      # Non-admin can only update their email through this controller.
      permitted = [:email]
      if admin?
        permitted.push(:first_name, :last_name, :username, :company_admin,
          :access_policy_id, :enabled)
        if action_sym == :create
          # There is a separate controller for password resets after the user is created.
          permitted.push(:password, :password_confirmation, :send_email)
        end
        permitted << :company_id if app_admin?
      end
      params.require(:auth_user).permit(permitted)
    end

    def setup_form_variables(record)
      # Setup options for the selects
      @companies = Company.all.order(:name) if app_admin?
      if action_sym == :new && app_admin?
        @access_policies = AccessPolicy.none
      else
        @access_policies = select_options(AccessPolicy, record.access_policy_id,
                              record.company_id).order(:description)
      end
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
      page.table = Auth::UsersIndexTable.new(current_user)

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
