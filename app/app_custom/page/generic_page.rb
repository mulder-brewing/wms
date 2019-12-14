class Page::GenericPage

  TYPES = Set[:index]

  SHARED_PATH = "shared/page/"

  attr_accessor :type_co, :records
  attr_writer :title

  def initialize(type, records = nil)
    @type_co = Constants::CO::SymbolSetEnum.new(type, TYPES)
    @records = records unless records.nil?
  end

  def title
    if !@title.blank?
      @title
    else
      @records.name.tableize + ".title." + @type_co.value_to_s
    end
  end

end
