class Page::GenericPage

  TYPES = Set[:index]

  SHARED_PATH = "shared/page/"
  INDEX_HTML_PATH = SHARED_PATH + "index"
  PAGINATION_HTML_PATH = SHARED_PATH + "pagination"
  ENABLED_FILTER_HTML_PATH = SHARED_PATH + "enabled_filter"
  RECORD_HTML_PATH = SHARED_PATH + "record"

  attr_accessor :type_co, :records, :table, :enabled_param
  attr_writer :title, :show_new_link, :show_enabled_filter

  def initialize(type, records)
    @type_co = Constants::CO::SymbolSetEnum.new(type, TYPES)
    @records = records
    @show_new_link = true
    @show_enabled_filter = true
  end

  def title
    if !@title.blank?
      @title
    else
      @records.name.tableize + ".title." + @type_co.value_to_s
    end
  end

  def new_path
    "new_#{@records.name.underscore}_path"
  end

  def index_path
    "#{@records.name.pluralize.underscore}_path"
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
