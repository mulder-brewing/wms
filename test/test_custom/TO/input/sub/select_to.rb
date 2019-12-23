class SelectTO < InputTO

  attr_accessor :options
  attr_writer :options_count

  def initialize(*args)
    @options = []
    super
  end

  def add_option(label, id, visible)
    option = OptionTO.new(label, id, visible)
    @options << option
  end

  def check_count?
    !@options_count.nil?
  end

  def options_count
    # Add 1 because a select always has a blank option
    @options_count + 1
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
