class Button::ModalCloseButton < Button::CloseButton

  def initialize(*)
    super
    @type = Button::Type::BUTTON
    @data_dismiss = "modal"
    @classes << "mr-2"
  end
end
