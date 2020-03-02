class Button::ModalCloseButton < Button::CloseButton

  def initialize(*)
    super
    @type = Button::Type::BUTTON
    @data_dismiss = "modal"
  end
end
