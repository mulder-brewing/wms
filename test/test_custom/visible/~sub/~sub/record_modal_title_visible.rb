class RecordModalTitleVisible < ModalTitleVisible

  def set_text(modal_type)
    @text = I18n.t("modal.title.#{modal_type}", :record=> @model_class.model_name.human)
  end
  
end
