class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  before_action :logged_in

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_url
  end

  def all_formats_redirect_to(path)
    respond_to do |format|
      format.html { redirect_to path }
      format.js { render js: "window.location = #{path.to_json}" }
    end
  end

  private

    def logged_in
      all_formats_redirect_to(root_url) unless logged_in?
    end

end
