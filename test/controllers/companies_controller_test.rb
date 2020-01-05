require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @app_admin = auth_users(:app_admin_user)
    @regular_user_company = @regular_user.company
    @company_admin_company = @company_admin.company
  end

  test 'only app admin can get new company modal' do
    # try not logged in
    get new_company_path, xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    get new_company_path, xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    get new_company_path, xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and get modal)
    log_in_as(@app_admin)
    get new_company_path, xhr:true
    assert_not_equal xhr_redirect, @response.body
    assert_match /create-modal/, @response.body
    assert_match /New Company/, @response.body
  end

  test 'only app admin can create a company' do
    # try not logged in
    assert_no_difference 'Company.count' do
      post companies_path, xhr: true, params: { company: { name: "Test Company A" } }
    end
    # try logged in as a regular user
    log_in_as(@regular_user)
    assert_no_difference 'Company.count' do
      post companies_path, xhr: true, params: { company: { name: "Test Company B" } }
    end
    # try logged in as a company admin user
    log_in_as(@company_admin)
    assert_no_difference 'Company.count' do
      post companies_path, xhr: true, params: { company: { name: "Test Company C" } }
    end
    # try logged in as a app admin (should work and create a company)
    log_in_as(@app_admin)
    assert_difference 'Company.count', 1 do
      post companies_path, xhr: true, params: { company: { name: "Test Company D" } }
    end
  end

  test 'only app admin can get show company modal' do
    # try not logged in
    get company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    get company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    get company_path(@company_admin_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and get modal)
    log_in_as(@app_admin)
    get company_path(@regular_user_company), xhr:true
    assert_not_equal xhr_redirect, @response.body
    assert_match /show-modal/, @response.body
    assert_match /Company/, @response.body
  end

  test 'only app admin can get edit a company modal' do
    # try not logged in
    get edit_company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    get edit_company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    get edit_company_path(@company_admin_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and get edit coompany modal)
    log_in_as(@app_admin)
    get edit_company_path(@regular_user_company), xhr:true
    assert_not_equal xhr_redirect, @response.body
    assert_match /update-modal/, @response.body
    assert_match /Edit Company/, @response.body
  end

  test 'only app admin can update a company' do
    updated_company_name = "Updated Name"
    # try not logged in
    patch company_path(@regular_user_company), xhr: true, params: { company: { name: updated_company_name } }
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    patch company_path(@regular_user_company), xhr: true, params: { company: { name: updated_company_name } }
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    patch company_path(@company_admin_company), xhr: true, params: { company: { name: updated_company_name } }
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and create a company)
    log_in_as(@app_admin)
    patch company_path(@regular_user_company), xhr: true, params: { company: { name: updated_company_name } }
    assert_not_equal xhr_redirect, @response.body
    @regular_user_company.reload
    assert_equal updated_company_name, @regular_user_company.name
  end

  test 'only app admin can get delete a company modal' do
    # try not logged in
    get destroy_modal_company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    get destroy_modal_company_path(@regular_user_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    get destroy_modal_company_path(@company_admin_company), xhr:true
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and get edit coompany modal)
    log_in_as(@app_admin)
    get destroy_modal_company_path(@regular_user_company), xhr:true
    assert_not_equal xhr_redirect, @response.body
    assert_match /destroy-modal/, @response.body
    assert_match /Delete Company/, @response.body
  end

  test 'only app admin can delete a company' do
    # try not logged in
    assert_no_difference 'Company.count' do
      delete company_path(@regular_user_company), xhr: true
    end
    assert_equal xhr_redirect, @response.body
    # try logged in as a regular user
    log_in_as(@regular_user)
    assert_no_difference 'Company.count' do
      delete company_path(@regular_user_company), xhr: true
    end
    assert_equal xhr_redirect, @response.body
    # try logged in as a company admin user
    log_in_as(@company_admin)
    assert_no_difference 'Company.count' do
      delete company_path(@company_admin_company), xhr: true
    end
    assert_equal xhr_redirect, @response.body
    # try logged in as a app admin (should work and create a company)
    log_in_as(@app_admin)
    assert_difference 'Company.count', -1 do
      delete company_path(@regular_user_company), xhr: true
    end
    assert_match /destroy-modal/, @response.body
    assert_match /Company deleted successfully/, @response.body
  end

  test 'only app admin can reach company index page' do
    # try not logged in
    get companies_path
    assert_redirected_to root_url
    # try logged in as a regular user
    log_in_as(@regular_user)
    get companies_path
    assert_redirected_to root_url
    # try logged in as a company admin user
    log_in_as(@company_admin)
    get companies_path
    assert_redirected_to root_url
    # try logged in as a app admin (should work and get index page)
    log_in_as(@app_admin)
    get companies_path
    assert_template 'companies/index'
  end

end
