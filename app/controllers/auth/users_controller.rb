class Auth::UsersController < Auth::BaseController
    include ModalHelper

    def new
      modal = new_modal(Auth::UserNewCreateForm)
      render_modal(modal)
    end

    def create
      modal = new_modal(Auth::UserNewCreateForm)
      modal.form.submit
      render_modal(modal)
    end

    def edit
      modal = new_modal(Auth::UserEditUpdateForm)
      render_modal(modal)
    end

    def update
      modal = new_modal(Auth::UserEditUpdateForm)
      modal.form.submit
      render_modal(modal)
    end

    def index
      index_page
    end

    private

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
