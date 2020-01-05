class Modal::DestroyModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :destroy
    @footer = Modal::Footers::DestroyFooter.new
    @title_suffix = "destroy"
  end

  def form?
    false
  end

  def render_path
    post_submit_path = Modal::FormRecordModal::VIEWS_PATH + "destroy"
    @form.post_submit? ? post_submit_path : Modal::FormRecordModal::JS_PATH
  end

end
