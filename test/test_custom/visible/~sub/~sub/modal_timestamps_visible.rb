class ModalTimestampsVisible < ModalFooterVisible

  def initialize(*)
    super
    @selector << " div.#{Modal::Footer::FormRecordFooter::TIMESTAMPS_CLASS} a"
    @text = I18n.t("timestamps.title")
  end

end
