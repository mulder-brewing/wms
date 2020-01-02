class Modal::FormRecordModal < Modal::FormModal

  attr_accessor :table, :persist, :role

  WRAPPER = "modal-wrapper"
  ID = "form-record-modal"

  VIEWS_PATH = "modals/form_modal/form_record_modal/"

  HTML_PATH = VIEWS_PATH + "modal"
  JS_PATH = VIEWS_PATH + "modal_js"
  SAVE_RESULT_PATH = VIEWS_PATH + "save_result"

  def initialize(form, table: nil)
    super(form)
    @table = table
  end

  def id
    ID
  end

  def wrapper
    WRAPPER
  end

  def html_path
    HTML_PATH
  end

  def persist?
    @persist
  end

  def role?(role)
    @role == role
  end

  def render_path
    @persist ? SAVE_RESULT_PATH : JS_PATH
  end

  def title
    form.record.class.name.tableize + ".title."
  end

end
