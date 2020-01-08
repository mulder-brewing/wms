class Button::IndexEditButton < Button::EditButton

  def initialize(*)
    super
    @remote = true
    index_action_style
  end

end
