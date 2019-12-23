class ModalForm::GenericModalForm

  WRAPPER = "modal-wrapper"

  TYPES = Set[:create, :show, :update, :destroy]

  SHARED_PATH = "shared/modal_form/"

  GENERIC_HTML_PATH = SHARED_PATH + "generic_modal"
  TIMESTAMPS_HTML_PATH = SHARED_PATH + "timestamps"

  GENERIC_JS_PATH = SHARED_PATH + "generic_modal_js"
  NEW_JS_PATH = SHARED_PATH + "new"
  SAVE_RESULT_JS_PATH = SHARED_PATH + "save_result"


  attr_accessor :type_co, :record, :modal, :form

  def initialize(type, record)
    @type_co = Constants::CO::SymbolSetEnum.new(type, TYPES)
    @type_s = @type_co.value_to_s
    @record = record
    @modal = ModalForm::GenericModal.new()
    @form = ModalForm::GenericForm.new()
  end

  def wrapper
    WRAPPER
  end

  def generic_js_path
    GENERIC_JS_PATH
  end

  def generic_html_path
    GENERIC_HTML_PATH
  end

  def new_js_path
    NEW_JS_PATH
  end

  def save_result_js_path
    SAVE_RESULT_JS_PATH
  end

  def timestamps_html_path
    TIMESTAMPS_HTML_PATH
  end

  def modal_id
    @modal.id
  end

  def modal_title
    @modal.title(@type_s, record)
  end

  def show_form?
    @modal.show_form?(@type_co)
  end

  def form_id
    @form.id
  end

  def form_path
    @form.path(@type_co, @record)
  end



end
