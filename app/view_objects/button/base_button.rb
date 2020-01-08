class Button::BaseButton
  include Button::Styling

  BASE_CLASS = "btn"

  attr_accessor :text_key, :style, :size, :classes, :test_id

  def initialize(**options)
    @remote = false
    @text_key = options[:text_key]
    @style = options[:style]
    @size = options[:size]
    @classes = []
    @classes << options[:class]
    @test_id = options[:test_id]
  end

  def btn_class
    return @final_calc_class unless @final_calc_class.nil?
    array = [BASE_CLASS, @style, @size, @test_id] + @classes
    @final_calc_class = array.select(&:present?).join(" ")
  end

end
