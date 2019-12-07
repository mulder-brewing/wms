class Page::GenericPage

  TYPES = Set[:index]

  SHARED_PATH = "shared/page/"
  INDEX_HTML_PATH = SHARED_PATH + "index"
  PAGINATION_HTML_PATH = SHARED_PATH + "pagination"
  RECORD_HTML_PATH = SHARED_PATH + "record"

  attr_accessor :type_co, :records, :show_new_link, :table
  attr_writer :title, :show_new_link

  def initialize(type, records)
    @type_co = Constants::CO::SymbolSetEnum.new(type, TYPES)
    @records = records
    @show_new_link = true
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

  def index_html_path
    INDEX_HTML_PATH
  end

  def pagination_html_path
    PAGINATION_HTML_PATH
  end

  def record_html_path
    RECORD_HTML_PATH
  end

  def show_new_link?
    show_new_link
  end

  def add_table(columns)
    @table = Table::GenericTable.new(columns)
  end

end
