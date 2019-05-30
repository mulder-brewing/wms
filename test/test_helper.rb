ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Shared return page title
  def wms_title (page_title)
    page_title + ' | Mulder WMS'
  end

end

class ActionDispatch::IntegrationTest
  def xhr_redirect
    'window.location = "http://www.example.com/"'
  end

  # Log in as a particular user.
  def log_in_as(user, password = "Password1$")
    post login_path, params: { session: { username: user.username, password: password, } }
  end

  def log_out()
    delete logout_path
  end
end
