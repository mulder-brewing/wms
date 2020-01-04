class Button::IndexEditButton < Button::EditButton

  def initialize(remote = true)
    super
    @remote = remote
    @size = Button::Size::SMALL
    @classes << "m-1"
  end

end
