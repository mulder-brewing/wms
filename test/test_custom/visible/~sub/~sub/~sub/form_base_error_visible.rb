class FormBaseErrorVisible < FormErrorVisible

  def initialize(*)
    super
    @selector << " div#feedback li.list-group-item"
  end

end
