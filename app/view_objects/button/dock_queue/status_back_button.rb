class Button::DockQueue::StatusBackButton < Button::DockQueue::CardRowButton

  def initialize(*)
    super
    @style = Button::Style::DANGER
    @classes << "text-left"
  end

  def text
    "&#10094; #{super}".html_safe
  end

end
