include Auth::SessionsHelper
include SimpleFormHelper
include TranslationHelper

class Table::BaseTable

  attr_accessor :records, :current_user, :controller, :columns, :insert_method,
    :wrapper

  def initialize(current_user, controller)
    @current_user = current_user
    @controller = controller
    @columns = []
  end

  def controller_model
    Controller::Model.call(@controller)
  end

end
