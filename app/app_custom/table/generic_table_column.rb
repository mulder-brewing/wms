class Table::GenericTableColumn

  TEXT_KEY_QUALIFIERS = Set[:global, :enabled, :custom]

  attr_accessor :name, :text_key, :send_chain
  attr_writer :add_edit_button, :add_become_button

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
      "simple_form.labels.defaults.enabled"
    end
  end

  def add_edit_button?
    @add_edit_button
  end

  def add_become_button?
    @add_become_button
  end

  def field_value(record)
    return record.send(@name) if @send_chain.nil?
    @send_chain.inject(record, :send)
  end


end
