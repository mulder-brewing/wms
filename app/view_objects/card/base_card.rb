class Card::BaseCard

  attr_accessor :image, :title_key, :text_key

  def initialize(**options)
    @image = options[:image]
    @title_key = options[:title_key]
    @text_key = options[:text_key]
  end

  def title
    I18n.t(@title_key)
  end

  def text
    I18n.t(@text_key)
  end

end
