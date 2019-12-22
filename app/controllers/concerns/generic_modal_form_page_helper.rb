module GenericModalFormPageHelper

  private

  def rc(record, action)
    return record unless self.respond_to?(:record_callback, true)
    record = record_callback(record, action)
  end

  def new_modal
    record = authorize controller_model.new
    record = rc(record, :new)
    modal_form = ModalForm::GenericModalForm.new(:create, record)
    respond_to do |format|
      format.js {
        render  :template => modal_form.generic_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def create_record(record = nil)
    if record.nil?
      record = controller_model.new(record_params)
      record.company_id ||= current_company_id
      record.current_user = current_user
    end
    authorize record
    record = rc(record, :create)
    record.save
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

  def edit_modal
    record = authorize find_record
    record = rc(record, :edit)
    modal_form = ModalForm::GenericModalForm.new(:update, record)
    respond_to do |format|
      format.js {
        render  :template => modal_form.generic_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def update_record(record = nil)
    if record.nil?
      record = find_record
      record.assign_attributes(record_params)
    end
    authorize record
    record = rc(record, :update)
    record.save
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
    page.add_table(table_array_hash) \
      if self.respond_to?(:table_array_hash, true)

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
