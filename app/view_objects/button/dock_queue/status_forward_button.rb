class Button::DockQueue::StatusForwardButton < Button::DockQueue::CardRowButton

  def initialize(*)
    super
    @style = Button::Style::PRIMARY
    @classes << "text-right"
  end

  def text
    "#{super} &#10097;".html_safe
  end

end
