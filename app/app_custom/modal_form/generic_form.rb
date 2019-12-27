class ModalForm::GenericForm

  attr_accessor :show_timestamps

  CREATE_UPDATE_FORM_FILE_NAME = "/create_update_form"
  ID = "generic-form"

  def initialize
    @show_timestamps = true
  end

  def id
    ID
  end

  def path(controller_path)
    controller_path + CREATE_UPDATE_FORM_FILE_NAME
  end

  def show_timestamps?
    @show_timestamps
  end

end
