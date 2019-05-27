class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_url
  end

end
