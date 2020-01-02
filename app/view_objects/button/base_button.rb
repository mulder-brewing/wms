class Button::BaseButton

  BASE_CLASS = "btn"

  attr_accessor :text_key, :style, :size, :remote, :classes

  def initialize(text_key, style)
    @text_key = text_key
    @style = style
    @remote = false
    @classes = []
  end

  def btn_class
    array = [BASE_CLASS, @style, @size.to_s] + @classes
    array.reject(&:empty?).join(" ")
  end

end
