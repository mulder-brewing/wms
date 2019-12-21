class IndexTo < GenericTO
  include Includes::NewPath
  include Includes::Title
  include Includes::IndexPath

  attr_writer :test_new, :test_enabled_filter,
    :test_edit, :test_pagination

  INDEX_TEMPLATE = Page::IndexListPage::INDEX_HTML_PATH

  def initialize(user, model, validity)
    @title_text_key = "index"
    super(user, model, validity)
  end

  def test(test)
    test.index_to_test(self)
  end

  def index_template
    INDEX_TEMPLATE
  end

  def check_visibility?
    !@visible_y_records.blank? || !@visible_n_records.blank?
  end

  def visible_y_records
    @visible_y_records ||= []
  end

  def visible_n_records
    @visible_n_records ||= []
  end

  def add_visible_y_record(record)
    @visible_y_records ||= []
    @visible_y_records << record
  end

  def add_visible_n_record(record)
    @visible_n_records ||= []
    @visible_n_records << record
  end

  def test_new?
    @test_new
  end

  def test_enabled_filter?
    @test_enabled_filter
  end

  def test_edit?
    @test_edit
  end

  def visible_edit_records
    @visible_edit_records ||= []
  end

  def add_visible_edit_record(record)
    @visible_edit_records ||= []
    @visible_edit_records << record
  end

  def test_pagination?
    @test_pagination
  end

end
