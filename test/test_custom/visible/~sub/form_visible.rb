class FormVisible < VisibleTO

  attr_accessor :form, :field

  def initialize(*)
    super
    @selector = "form"
  end

end
