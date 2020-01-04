class Table::Column::BaseColumn

  attr_accessor :text_key, :id

  def initialize(text_key)
    @text_key = text_key
  end

  def actions?
    false
  end

  def buttons?
    false
  end

end
