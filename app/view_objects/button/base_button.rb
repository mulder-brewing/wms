class Button::BaseButton

  BASE_CLASS = "btn"

  STYLES = {  primary: "btn-primary",
              secondary: "btn-secondary",
              success: "btn-success",
              danger: "btn-danger",
              warning: "btn-warning",
              info: "btn-info",
              light: "btn-light",
              dark: "btn-dark",
              link: "btn-link" }

  SIZES = { small: "btn-sm",
            large: "btn-lg" }

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
