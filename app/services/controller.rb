module Controller

  class Model < ApplicationService
    # Returns the default model a controller backs.
    def initialize(controller)
      @controller = controller
    end

    def call
      return @controller.controller_path.classify.constantize
    end
  end

end
