class Page::GenericPage

  TYPES = Set[:index]

  attr_accessor :type_co, :records
  attr_writer :title

  def initialize(type, records)
    @type_co = Constants::CO::SymbolSetEnum.new(type, TYPES)
    @records = records
  end

  def title
    if !@title.blank?
      @title
    else
      @records.class.name.pluralize.underscore + ".title." + @type_co.value_to_s
    end
  end

end
