module GenericModalFormPageHelper


  private

  def rc(record)
    record_callback(record) if self.respond_to?(:record_callback, true)
  end

  def mfc(modal_form)
    modal_form_callback(modal_form) if self.respond_to?(:modal_form_callback, true)
  end

  def setup_table
    return nil unless self.respond_to?(:table_array_hash, true)
    Table::GenericTable.new(table_array_hash)
  end

  def new_modal
    record = authorize controller_model.new
    rc(record)
    modal_form = ModalForm::GenericModalForm.new(:create, record)
    mfc(modal_form)
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
    rc(record)
    record.is_a?(BaseForm) ? record.submit : record.save
    modal_form = ModalForm::GenericModalForm.new(:create, record)
    mfc(modal_form)
    table = setup_table
    respond_to do |format|
      format.js {
        render  :template => modal_form.save_result_js_path,
                :locals => {  modal_form: modal_form,
                              table: table
                            }
      }
    end
  end

  def edit_modal(record = nil)
    if record.nil?
      record = form? ? controller_model.new(param_id_with_current_user) : find_record
    end
    authorize record
    rc(record)
    modal_form = ModalForm::GenericModalForm.new(:update, record)
    mfc(modal_form)
    respond_to do |format|
      format.js {
        render  :template => modal_form.generic_js_path,
                :locals => { modal_form: modal_form }
      }
    end
  end

  def update_record(record = nil)
    if record.nil?
      record = form? ? controller_model.new(param_id_with_current_user) : find_record
      record.assign_attributes(record_params)
    end
    authorize record
    rc(record)
    record.is_a?(BaseForm) ? record.submit : record.save
    modal_form = ModalForm::GenericModalForm.new(:update, record)
    mfc(modal_form)
    table = setup_table
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
    page.new_record = controller_model.new
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
