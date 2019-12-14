class StaticPagesController < ApplicationController
  skip_before_action :logged_in, :only => [:home]
  before_action :skip_authorization

  def home
  end
end
