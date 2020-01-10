class Modal::Footer::DestroyFooter < Modal::Footer::FormRecordFooter

  def initialize(*)
    super
    @buttons << Button::ModalDeleteButton.new(record: @form.record)
    @show_timestamps = false
  end

end
