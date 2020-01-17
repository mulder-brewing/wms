class Modal::FormRecordModal < Modal::FormModal

  attr_accessor :table, :persist, :role, :title_suffix

  VIEWS_PATH = "modals/form_modal/form_record_modal/"

  HTML_PATH = VIEWS_PATH + "modal"
  JS_PATH = VIEWS_PATH + "modal_js"
  SAVE_RESULT_PATH = VIEWS_PATH + "save_result"

  def initialize(form, table: nil)
    super(form)
    @table = table
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
    if @title.is_a? String
      I18n.t(@title)
    else
      I18n.t("modal.title.#{@title_suffix}",
        :record=> form.record.model_name.human)
    end
  end

end
