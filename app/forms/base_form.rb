class BaseForm
  include ActiveModel::Model
  include Auth::SessionsHelper

  attr_accessor :current_user, :controller

  def initialize(current_user, controller)
    @current_user = current_user
    @controller = controller
  end


end