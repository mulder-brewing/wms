class DestroyMessageVisible < ModalBodyVisible

  attr_accessor :to_delete

  def initialize(*)
    super
    raise ArgumentError if @to_delete.nil?
    @text = I18n.t("modal.chicken_message", :target=> @to_delete,
      :action=>I18n.t("actions.delete").downcase)
  end

end
