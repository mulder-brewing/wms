class Button::ModalSaveButton < Button::SaveButton

  def initialize(form:, **options)
    super(options)
    @form = form
    @type = Button::Type::SUBMIT
  end

end
