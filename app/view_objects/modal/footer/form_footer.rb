class Modal::Footer::FormFooter < Modal::Footer::BaseFooter

  attr_accessor :buttons, :form

  def initialize(form)
    @form = form
    @buttons = []
    @buttons << Button::ModalCloseButton.new
  end

  def buttons_with_margin
    x = 0
    while x < (@buttons.count - 1)
      @buttons[x].classes << "mr-2"
      x += 1
    end
    return @buttons
  end


end
