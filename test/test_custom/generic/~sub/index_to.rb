class IndexTo < GenericTO
  include Includes::IndexPath

  attr_accessor :index_template

  INDEX_TEMPLATE = Page::IndexListPage::INDEX_HTML_PATH

  def initialize(*)
    super
    @index_template = INDEX_TEMPLATE
  end

  def test(test)
    test.index_to_test(self)
  end

end
