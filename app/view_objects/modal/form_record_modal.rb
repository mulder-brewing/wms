class Modal::FormRecordModal < Modal::FormModal

  attr_accessor :table, :save_result, :page, :persist, :role, :title_suffix

  VIEWS_PATH = "modals/form_modal/form_record_modal/"

  HTML_PATH = VIEWS_PATH + "modal"
  JS_PATH = VIEWS_PATH + "modal_js"
  SAVE_RESULT_PATH = VIEWS_PATH + "save_result"
  ERROR_PATH = VIEWS_PATH + "modal_error"

  def initialize(form, page: nil, table: nil)
    super(form)
    @page = page
    @table = table
    @success_msg = I18n.t("alert.save.success")
  end

  def html_path
    HTML_PATH
  end

  def error_path
    ERROR_PATH
  end

  def persist?
    @persist
  end

  def role?(*args)
    args.include? role
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

  def render_record
    ApplicationController.render partial: table.record_html_path, locals: { record: form.record, table: table }
  end

  def record_id
    '#' << table.row_id(form.record)
  end

end
