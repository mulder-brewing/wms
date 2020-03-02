class BaseForm
  include ActiveModel::Model
  include Auth::SessionsHelper

  attr_accessor :current_user, :controller, :post_submit

  def initialize(current_user, controller)
    @current_user = current_user
    @controller = controller
  end

  def controller_model
    ControllerUtil.model(@controller)
  end

  def action?(*args)
    args.include? controller.action_name.to_sym
  end

  def submit(*args, &block)
    @post_submit = true
    private_submit(*args, &block)
  end

  def post_submit?
    post_submit
  end

end
