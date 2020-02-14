class Button::BaseButton
  include Button::Styling

  BASE_CLASS = "btn"

  attr_accessor :remote, :text_key, :style, :size, :classes, :block, :btn_id

  delegate :class_name, to: :class

  def initialize(**options)
    @remote = options[:remote] || false
    @text_key = options[:text_key]
    @style = options[:style]
    @size = options[:size]
    @classes = []
    @classes << options[:class]
    @block = options[:block]
    @btn_id = options[:btn_id]
  end

  def btn_class
    return @final_calc_class unless @final_calc_class.nil?
    @classes << "btn-block" if block?
    array = [BASE_CLASS, style, size, class_name] + classes
    @final_calc_class = array.select(&:present?).join(" ")
  end

  def self.class_name
    name.demodulize
  end

  def block?
    block
  end

  def text
    I18n.t(text_key)
  end

end
