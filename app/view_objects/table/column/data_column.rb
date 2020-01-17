class Table::Column::DataColumn < Table::Column::IndexColumn

  attr_accessor :t_class, :attribute, :send_chain

  def initialize(**options)
    super(options)
    @t_class = options[:t_class]
    @attribute = options[:attribute]
    @send_chain = Array(options[:send_chain])
  end

  def header_title
    if t_class && attribute
      t_class.human_attribute_name(attribute)
    else
      super
    end
  end

  def field_value(record)
    unless @send_chain.empty?
      @send_chain.inject(record, :send)
    else
      record.send(attribute)
    end
  end

end
