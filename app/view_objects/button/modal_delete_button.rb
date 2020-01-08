class Button::ModalDeleteButton < Button::DeleteButton

  def initialize(*)
    super
    @method = :delete
    @remote = true
  end

  def record_path(record)
    return record
  end

end
