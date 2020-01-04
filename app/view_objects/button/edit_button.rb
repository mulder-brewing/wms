class Button::EditButton < Button::BaseButton

  def initialize(*)
    super("actions.edit", Button::Style::PRIMARY)
  end

  def path(record)
    Util::Paths::Edit.call(record)
  end

end
