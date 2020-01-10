class Modal::BaseModal

  WRAPPER = "modal-wrapper"
  ID = "generic-modal"
  HEADER_CLASS = "modal-header"
  TITLE_CLASS = "modal-title"
  BODY_CLASS = "modal-body"
  FOOTER_CLASS = "modal-footer"

  attr_accessor :footer, :title

  def id
    ID
  end

  def wrapper
    WRAPPER
  end

  def header_class
    HEADER_CLASS
  end

  def title_class
    TITLE_CLASS
  end

  def body_class
    BODY_CLASS
  end

  def footer_class
    FOOTER_CLASS
  end

end
