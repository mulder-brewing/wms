class Modal::Footer::ShowFooter < Modal::Footer::FormRecordFooter

  def initialize(*)
    super
    @show_timestamps = false
  end

end
