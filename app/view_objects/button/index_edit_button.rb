class Button::IndexEditButton < Button::EditButton

  def initialize(**options)
    super(options)
    @remote = true
    @size = Button::Size::SMALL
    @classes << "m-1"
  end

end
