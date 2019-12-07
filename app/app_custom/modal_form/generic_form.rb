class ModalForm::GenericForm

  CREATE_UPDATE_FORM_FILE_NAME = "create_update_form"

  def id(type_s)
    type_s + "-form"
  end

  def path(type_co, record)
    if type_co.create? || type_co.update?
      record.class.view_folder_path +
        CREATE_UPDATE_FORM_FILE_NAME unless record.nil?
    end
  end

end
