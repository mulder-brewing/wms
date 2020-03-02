class Button::ModalVoidButton < Button::VoidButton

  def initialize(*)
    super
    @method = :patch
    @remote = true
  end

  def record_path(record)
    return record
  end

end
