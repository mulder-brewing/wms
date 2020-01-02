class Page::IndexListPageToDelete < Page::GenericPage

  INDEX_HTML_PATH = SHARED_PATH + "index"
  PAGINATION_HTML_PATH = SHARED_PATH + "pagination"
  ENABLED_FILTER_HTML_PATH = SHARED_PATH + "enabled_filter"
  RECORD_HTML_PATH = SHARED_PATH + "record"

  attr_accessor :table, :enabled_param, :recordsSendArray,
    :table_array_hash, :new_record
  attr_writer :show_new_link, :show_enabled_filter

  def initialize(records = nil)
    super(:index, records)
    @show_new_link = true
    @show_enabled_filter = true
  end

  def index_html_path
    INDEX_HTML_PATH
  end

  def pagination_html_path
    PAGINATION_HTML_PATH
  end

  def enabled_filter_html_path
    ENABLED_FILTER_HTML_PATH
  end

  def record_html_path
    RECORD_HTML_PATH
  end

  def show_new_link?
    @show_new_link
  end

  def show_enabled_filter?
    @show_enabled_filter
  end

  def add_table(columns)
    @table = Table::GenericTable.new(columns)
  end

  def button_class(button)
    case button
    when :all
      @enabled_param.nil? ? "btn-primary" : "btn-secondary"
    when :enabled
      @enabled_param ? "btn-primary" : "btn-secondary"
    when :disabled
      @enabled_param == false ? "btn-primary" : "btn-secondary"
    end
  end
end
