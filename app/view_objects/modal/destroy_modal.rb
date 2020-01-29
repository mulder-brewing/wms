class Modal::DestroyModal < Modal::ChickenModal

  def initialize(*)
    super
    @role = :destroy
    @save_result = Table::SaveResult::REMOVE
    @footer = Modal::Footer::DestroyFooter.new(@form)
    @title_suffix = "destroy"
    @success_msg = I18n.t("alert.delete.success")
    @error_msg = I18n.t("alert.delete.failure")
  end

  def chicken_message
    super(I18n.t("actions.delete").downcase)
  end

end
