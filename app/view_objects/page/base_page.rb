class Page::BasePage

  attr_accessor :controller, :title

  def initialize(controller, title = nil)
    @controller = controller
    @title = title
  end

  def controller_model
    Controller::Model.call(@controller)
  end

end
