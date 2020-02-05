class Table::Column::EnabledColumn < Table::Column::IndexColumn

  def header_title
    I18n.t("attributes.enabled")
  end

  def enabled_value?
    true
  end

  def field_value(record)
    BooleanUtil.yes_no(record.enabled)
  end

end
