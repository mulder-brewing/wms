class HeaderTitleVisible < HeaderVisible

  def initialize(*)
    super
    @class = "page-title"
    @text = I18n.t(@text)
  end
end
