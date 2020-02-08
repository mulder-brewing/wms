module ControllerUtil

  def self.model(controller)
    return controller.controller_path.classify.constantize
  end
  
end
