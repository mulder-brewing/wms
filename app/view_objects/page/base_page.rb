include Auth::SessionsHelper

class Page::BasePage

  attr_accessor :current_user, :controller, :title, :pagy

  def initialize(current_user, controller, title = nil)
    @current_user = current_user
    @controller = controller
    @title = title
  end

  def controller_model
    ControllerUtil.model(@controller)
  end

end
