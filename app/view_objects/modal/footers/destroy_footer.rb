class Modal::Footers::DestroyFooter < Modal::Footers::FormRecordFooter

  def initialize
    super
    @buttons.push(:close, :delete)
    @show_timestamps = false
  end

end
