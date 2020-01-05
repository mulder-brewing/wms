class Table::Column::EnabledColumn < Table::Column::IndexColumn

  def initialize
    super("global.boolean.enabled")
  end

  def enabled_value?
    true
  end

  def field_value(record)
    Util::Boolean::YesNo.call(record.enabled)
  end

end
