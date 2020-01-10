class IndexTo < GenericTO
  include Includes::NewPath
  include Includes::IndexPath

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

end
