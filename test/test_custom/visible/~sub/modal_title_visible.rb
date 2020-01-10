class ModalTitleVisible < VisibleTO

  def initialize(*)
    super
    @selector = "div.#{Modal::BaseModal::HEADER_CLASS} > h5.#{Modal::BaseModal::TITLE_CLASS}"
    @text = I18n.t(@text)
  end

end
