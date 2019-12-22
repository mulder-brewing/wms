class SelectTO < InputTO

  attr_accessor :options

  def add_option(label, id, visible)
    @options ||= []
    option = OptionTO.new(label, id, visible)
    @options << option
  end

  class OptionTO

    attr_accessor :label, :id, :visible

    def initialize(label, id, visible)
      @label = label
      @id = id
      @visible = visible
    end

  end

end
