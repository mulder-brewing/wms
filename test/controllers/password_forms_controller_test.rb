require 'test_helper'

class PasswordFormsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get password_forms_edit_url
    assert_response :success
  end

  test "should get update" do
    get password_forms_update_url
    assert_response :success
  end

end
