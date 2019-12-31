class Table::Column::DataColumn < Table::Column::IndexColumn

  attr_accessor :send_chain

  def initialize(text_key, send_chain)
    super(text_key)
    @send_chain = Array(send_chain)
  end

  def field_value(record)
    @send_chain.inject(record, :send)
  end

end
