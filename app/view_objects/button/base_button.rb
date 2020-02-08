class Button::BaseButton
  include Button::Styling

  BASE_CLASS = "btn"

  attr_accessor :remote, :text_key, :style, :size, :classes, :block, :btn_class,
    :btn_id

  def initialize(**options)
    @remote = false
    @text_key = options[:text_key]
    @style = options[:style]
    @size = options[:size]
    @classes = []
    @classes << options[:class]
    @block = options[:block]
    @btn_class = options[:btn_class] || safe_const_get("BTN_CLASS")
    @btn_id = options[:btn_id] || safe_const_get("BTN_ID")
  end

  def btn_class
    return @final_calc_class unless @final_calc_class.nil?
    @classes << "btn-block" if block?
    array = [BASE_CLASS, @style, @size, @btn_class] + @classes
    @final_calc_class = array.select(&:present?).join(" ")
  end

  def block?
    block
  end

  def text
    I18n.t(text_key)
  end

  private

  def safe_const_get(const)
    self.class.const_get(const) if self.class.const_defined?(const)
  end

end
