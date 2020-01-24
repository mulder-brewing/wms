class Modal::ShowModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :show
    @footer = Modal::Footer::ShowFooter.new(@form)
    @title_suffix = "show"
  end

  def form?
    false
  end

end
