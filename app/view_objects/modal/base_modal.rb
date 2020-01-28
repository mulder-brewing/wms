class Modal::BaseModal

  WRAPPER = "modal-wrapper"
  ID = "generic-modal"
  HEADER_CLASS = "modal-header"
  TITLE_CLASS = "modal-title"
  BODY_CLASS = "modal-body"
  FOOTER_CLASS = "modal-footer"

  attr_accessor :footer, :title, :error, :error_js_path, :success_msg
  attr_writer :error_msg, :secondary_error_msg

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

  def error?
    Util::Boolean.cast(error)
  end

  def error_msg
    @error_msg ||= I18n.t("errors.unknown")
  end

  def secondary_error_msg
    @secondary_error_msg
  end

end
