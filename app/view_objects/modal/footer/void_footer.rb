class Modal::Footer::VoidFooter < Modal::Footer::FormRecordFooter

  def initialize(*)
    super
    @buttons << Button::ModalVoidButton.new(record: form)
    @show_timestamps = false
  end

end
