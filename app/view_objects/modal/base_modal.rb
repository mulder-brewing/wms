class Modal::BaseModal

  WRAPPER = "modal-wrapper"
  ID = "generic-modal"

  attr_accessor :footer

  def id
    ID
  end

  def wrapper
    WRAPPER
  end

end
