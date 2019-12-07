class Table::GenericTableColumn

  TEXT_KEY_QUALIFIERS = Set[:global, :enabled, :custom]

  attr_accessor :name, :text_key
  attr_writer :add_edit_button

  def initialize(name, text_key_qualifier)
    @name = name
    @text_key_qualifier_co =
      Constants::CO::SymbolSetEnum.new(text_key_qualifier, TEXT_KEY_QUALIFIERS)
  end

  def header_text_key
    return text_key unless text_key.nil?
    case @text_key_qualifier_co.value
    when :global
      "global." + name.to_s
    when :enabled
      "global.boolean.enabled_disabled.enabled"
    end
  end

  def add_edit_button?
    @add_edit_button
  end


end
