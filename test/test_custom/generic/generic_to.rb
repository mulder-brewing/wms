include ActionDispatch::Routing::PolymorphicRoutes
include ActiveModel::Translation

class GenericTO

  attr_accessor :user,
                :model,
                :validity,
                :visibles,
                :debug,
                :path,
                :xhr,
                :select_jquery_method,
                :controller,
                :action,
                :form_class

  def initialize(user, model, validity, **options)
    @user = user
    @model = model
    @validity = validity
    @visibles = []
    @debug = options[:debug]
    @path = options[:path]
    @xhr = options[:xhr] || true
    @select_jquery_method = options[:select_jquery_method]
    @controller = options[:controller]
    @form_class = options[:form_class]
  end

  def disable_user_access_policy
    @user.access_policy.update_column(:enabled, false)
  end

  def enable_everything_permission
    @user.access_policy.update_column(:everything, true)
  end

  def enable_model_permission(permission = nil)
    permission ||= @model.table_name
    @user.access_policy.update_column(permission, true)
  end

  def model_class
    @model_class ||= @model.class
  end

  def model_count
    model_class.count
  end

  def xhr_switch_params(p = {})
    p = { xhr: true }.merge(p) if xhr
    return p
  end

  def test_visibles?
    !@visibles.empty?
  end

  def xhr?
    @xhr
  end

  def controller_action_path(**args)
    return nil unless controller.present? && action.present?
    PathUtil.controller_action(controller, action, args)
  end

end
