class ModalForm::GenericForm

  CREATE_UPDATE_FORM_FILE_NAME = "create_update_form"
  ID = "generic-form"

  def id
    ID
  end

  def path(type_co, record)
    if type_co.create? || type_co.update?
      record.class.view_folder_path +
        CREATE_UPDATE_FORM_FILE_NAME unless record.nil?
    end
  end

end
