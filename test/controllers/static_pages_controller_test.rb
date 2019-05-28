require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Mulder WMS"
  end

  test "should get home with link to login when not logged in" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "#{@base_title}"
    assert_select "a[href=?]", "/login"
  end

end
