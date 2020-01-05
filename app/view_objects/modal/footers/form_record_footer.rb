class Modal::Footers::FormRecordFooter < Modal::Footers::FormFooter

  attr_accessor :show_timestamps

  def initialize
    super
  end

  def show_timestamps?
    @show_timestamps
  end

end
