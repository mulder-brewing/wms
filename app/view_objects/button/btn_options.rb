module Button::BtnOptions

  attr_accessor :type, :data_dismiss, :form

  def btn_options
    { type: @type, 'data-dismiss': @data_dismiss, class: btn_class,
      form: @form }
  end

end
