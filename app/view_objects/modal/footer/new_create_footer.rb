class Modal::Footer::NewCreateFooter < Modal::Footer::FormRecordFooter

  def initialize(*)
    super
    @buttons << Button::ModalSaveButton.new(form: @form.html_id)
    @show_timestamps = false
  end

end
