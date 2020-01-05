class Button::DeleteButton < Button::BaseButton

  def initialize(*)
    super("actions.delete", Button::Style::DANGER)
    @remote = true
    @size = Button::Size::SMALL
    @classes << "m-1"
  end

  def path(record)
    Util::Paths::Path.call(:destroy_modal_company_path, id: record.id)
  end

end
