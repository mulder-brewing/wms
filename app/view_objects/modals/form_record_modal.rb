class Modals::FormRecordModal < Modals::FormModal

  attr_accessor :table, :persist, :role

  WRAPPER = "modal-wrapper"
  CSS_ID = "form-record-modal"

  VIEWS_PATH = "modals/form_modal/form_record_modal/"

  HTML_PATH = VIEWS_PATH + "modal"
  JS_PATH = VIEWS_PATH + "modal_js"
  SAVE_RESULT_PATH = VIEWS_PATH + "save_result"

  def css_id
    CSS_ID
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
    form.record.modal_title
  end

end
