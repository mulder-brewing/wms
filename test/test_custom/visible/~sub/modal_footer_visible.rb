class ModalFooterVisible < VisibleTO

  def initialize(*)
    super
    @selector = "div.#{Modal::BaseModal::FOOTER_CLASS}"
  end

end
