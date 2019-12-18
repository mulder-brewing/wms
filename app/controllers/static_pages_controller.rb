class StaticPagesController < ApplicationController
  skip_before_action :logged_in, :only => [:home]
  before_action :skip_authorization
  before_action :skip_policy_scope

  def home
  end
end
