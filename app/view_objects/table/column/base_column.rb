class Table::Column::BaseColumn

  attr_accessor :title, :text_key, :id

  def initialize(**options)
    @title = options[:title]
    @text_key = options[:text_key]
  end

  def actions?
    false
  end

  def buttons?
    false
  end

  def header_title
    title || I18n.t(text_key)
  end

end
