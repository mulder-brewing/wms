class FormSelectOptionVisible < FormFieldVisible

  attr_accessor :option_id

  def initialize(*)
    super
    # add 1 to the count because there's one blank option in a select.
    @count += 1 if @count.is_a?(Numeric) && @option_id.nil?
  end

  def select
    option = " option"
    option << "[value=#{@option_id}]" unless @option_id.nil?
    super + option
  end

end
