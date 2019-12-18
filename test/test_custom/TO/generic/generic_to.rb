include ActionDispatch::Routing::PolymorphicRoutes
include Rails.application.routes.url_helpers

class GenericTO

  attr_accessor :user, :validity, :model

  def initialize(user, model, validity)
    @user = user
    @model = model
    @validity = validity
  end
end
