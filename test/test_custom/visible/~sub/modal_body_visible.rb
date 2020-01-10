class ModalBodyVisible < VisibleTO

  def initialize(*)
    super
    @selector = "div.#{Modal::BaseModal::BODY_CLASS}"
  end

end
