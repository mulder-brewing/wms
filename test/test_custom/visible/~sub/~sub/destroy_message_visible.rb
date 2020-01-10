class DestroyMessageVisible < ModalBodyVisible

  attr_accessor :to_delete

  def initialize(*)
    super
    raise ArgumentError if @to_delete.nil?
    @text = I18n.t("modal.destroy.chicken_message", :to_delete=> @to_delete)
  end

end
