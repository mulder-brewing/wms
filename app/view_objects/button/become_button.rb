class Button::BecomeButton < Button::IndexButton

  def initialize
    super("auth/users.become", STYLES[:primary])
    @size = SIZES[:small]
    @classes << "m-1"
  end

  def path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end
