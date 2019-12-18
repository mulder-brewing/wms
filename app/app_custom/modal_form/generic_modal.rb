class ModalForm::GenericModal
  WRAPPER = "modal-wrapper"
  ID = "generic-modal"

  attr_writer :title

  def id
    ID
  end

  def title(type_s, record)
    if !@title.blank?
      @title
    else
      record.class.name.pluralize.underscore + ".title." + type_s
    end
  end

  def show_form?(type)
    type.create? || type.update?
  end

end
