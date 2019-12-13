module GenericModalFormPageHelper

  private

  def new_modal
    record = controller_model.new
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
      record.company_id = current_company_id
    end
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
    record = find_record
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
      record.assign_attributes(record_params) unless record.nil?
    end
    record.save unless record.nil?
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

  def index_page(recordSendArray = nil)
    enabled = ActiveRecord::Type::Boolean.new.deserialize(params[:enabled])
    records = controller_model.where_company(current_company_id)
    records = records.where_enabled(enabled) unless enabled.nil?
    records = Array(recordSendArray) \
      .inject(records) { |o, a| o.send(*a) } unless recordSendArray.nil?

    pagy, records = pagy(records, items:25)

    page = Page::GenericPage.new(:index, records)
    page.add_table(table_array_hash)
    page.enabled_param = enabled

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
