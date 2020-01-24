class Modal::ShowModal < Modal::FormRecordModal

  attr_accessor :show

  def initialize(form, show: nil)
    super(form)
    @role = :show
    @footer = Modal::Footer::ShowFooter.new(@form)
    @title_suffix = "show"
    @show = show
  end

end
