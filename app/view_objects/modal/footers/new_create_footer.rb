class Modal::Footers::NewCreateFooter < Modal::Footers::FormRecordFooter

  def initialize
    super
    @show_timestamps = false
  end

end
