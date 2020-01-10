include ActionDispatch::Routing::PolymorphicRoutes
include ActiveModel::Translation

class GenericTO

  attr_accessor :user, :validity, :model, :debug, :path, :xhr, :visibles, :select_jquery_method

  def initialize(user, model, validity)
    @user = user
    @model = model
    @validity = validity
    @xhr = true
    @visibles = []
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

  def xhr_switch_params(p = {})
    p = { xhr: true }.merge(p) if xhr
    return p
  end

  def test_visibles?
    !@visibles.empty?
  end

end
