class Button::BaseButton
  include Button::Styling

  BASE_CLASS = "btn"

  attr_accessor :remote, :text_key, :style, :size, :classes, :btn_class

  def initialize(**options)
    @remote = false
    @text_key = options[:text_key]
    @style = options[:style]
    @size = options[:size]
    @classes = []
    @classes << options[:class]
    @btn_class = options[:test_id]
  end

  def btn_class
    return @final_calc_class unless @final_calc_class.nil?
    array = [BASE_CLASS, @style, @size, @btn_class] + @classes
    @final_calc_class = array.select(&:present?).join(" ")
  end

end
