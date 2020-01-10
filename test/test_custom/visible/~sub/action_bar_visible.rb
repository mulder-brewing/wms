class ActionBarVisible < VisibleTO

  def initialize(*)
    super
    @selector = "main div.#{Page::IndexListPage::ACTION_BAR_CLASS}"
  end

end
