class Button::IndexDeleteButton < Button::DeleteButton

  attr_accessor :destroy_path

  def initialize(**options)
    super
    @destroy_path = options.fetch(:destroy_path)
    @remote = true
    index_action_style
  end

  def record_path(record)
    PathUtil.path(@destroy_path, id: record.id)
  end

end
