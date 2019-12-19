class IndexTo < GenericTO

  attr_accessor :visible_y_records, :visible_n_records

  INDEX_TEMPLATE = Page::IndexListPage::INDEX_HTML_PATH

  def test(test)
    test.index_to_test(self)
  end

  def index_path
    polymorphic_path(@model)
  end

  def index_template
    INDEX_TEMPLATE
  end

  def check_visibility?
    !@visible_y_records.blank? || !@visible_n_records.blank?
  end

  def add_visible_y_record(record)
    @visible_y_records ||= []
    @visible_y_records << record
  end

  def add_visible_n_record(record)
    @visible_n_records ||= []
    @visible_n_records << record
  end

end
