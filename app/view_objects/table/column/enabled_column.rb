class Table::Column::EnabledColumn < Table::Column::IndexColumn

  def header_title
    I18n.t("attributes.enabled")
  end

  def enabled_value?
    true
  end

  def field_value(record)
    Util::Boolean::YesNo.call(record.enabled)
  end

end
