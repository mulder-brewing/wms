class Modal::Footers::NewCreateFooter < Modal::Footers::FormRecordFooter

  def initialize
    super
    @buttons.push(:close, :save)
    @show_timestamps = false
  end

end
