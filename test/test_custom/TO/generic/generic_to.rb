include ActionDispatch::Routing::PolymorphicRoutes
include Rails.application.routes.url_helpers
include ActiveModel::Translation

class GenericTO

  attr_accessor :user, :validity, :model

  def initialize(user, model, validity)
    @user = user
    @model = model
    @validity = validity
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

end
