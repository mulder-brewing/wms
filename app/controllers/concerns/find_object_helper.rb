module FindObjectHelper

    private

    def find_object_with_current_user(model, id = nil)
      object = find_object_by_id(model, id)
      raise_not_found if object.nil?
      object_with_current_user = set_current_user(object)
      return object_with_current_user
    end

    def find_object_by_id(model, id)
      id ||= params[:id]
      return model.find_by(id: id)
    end

    def find_record
      find_object_with_current_user(controller_model)
    end

    def set_current_user(object)
      object.current_user = current_user
      return object
    end

    def controller_model
      controller_path.classify.constantize
    end

    def raise_not_found
      raise ApplicationController::RecordNotFound
    end

    def form?
      controller_model < BaseForm
    end

    def param_id
      params.extract!(:id).permit(:id).merge(:current_user => current_user)
    end

end
