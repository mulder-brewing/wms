class Table::IndexTable < Table::BaseTable

  TABLE_CLASS = "index-table"
  HEAD_CLASS = "index-table-head"
  BODY_CLASS = "index-table-body"

  SHARED_PATH = "shared/table/"
  JS_PATH = SHARED_PATH + "table_js"
  HTML_PATH = SHARED_PATH + "table"
  RECORD_HTML_PATH = SHARED_PATH + "record"

  delegate :row_id, to: :class

  def initialize(*)
    super
    @insert_method = Table::Insert::PREPEND
  end

  def prep_records(params)
    @records = controller_model.all
    enabled = BooleanUtil.cast(params[:enabled])
    @records = @records.where_enabled(enabled) unless enabled.nil?
    return records
  end

  def table_class
    TABLE_CLASS
  end

  def head_class
    HEAD_CLASS
  end

  def body_class
    BODY_CLASS
  end

  def js_path
    JS_PATH
  end

  def html_path
    HTML_PATH
  end

  def record_html_path
    RECORD_HTML_PATH
  end

  def self.row_id(record)
    record.class.name.parameterize + "-" + record.id.to_s;
  end

  def render_table
    ApplicationController.render partial: html_path, locals: { table: self }
  end

end
