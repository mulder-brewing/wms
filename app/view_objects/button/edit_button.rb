class Button::EditButton < Button::IndexButton

  def initialize(remote = true)
    super("modal.edit", STYLES[:primary])
    @remote = remote
    @size = SIZES[:small]
    @classes << "m-1"
  end

  def path(record)
    Util::Paths::Edit.call(record)
  end

end
