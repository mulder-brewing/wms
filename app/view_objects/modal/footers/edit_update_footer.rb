class Modal::Footers::EditUpdateFooter < Modal::Footers::FormRecordFooter

  def initialize
    super
    @buttons.push(:close, :save)
    @show_timestamps = true
  end

end
