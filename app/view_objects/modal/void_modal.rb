class Modal::VoidModal < Modal::ChickenModal

  def initialize(*)
    super
    @role = :void
    @footer = Modal::Footer::VoidFooter.new(@form)
    @title_suffix = "void"
    @success_msg = I18n.t("alert.void.success")
    @error_msg = I18n.t("alert.void.failure")
  end

  def chicken_message
    super(I18n.t("actions.void").downcase)
  end

end
