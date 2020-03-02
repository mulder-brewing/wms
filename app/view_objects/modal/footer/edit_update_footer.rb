class Modal::Footer::EditUpdateFooter < Modal::Footer::FormRecordFooter

  def initialize(*)
    super
    @buttons << Button::ModalSaveButton.new(form: @form.html_id)
    @show_timestamps = true
  end

end
