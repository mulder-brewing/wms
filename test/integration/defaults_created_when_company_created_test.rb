require 'test_helper'
require 'pp'

class DefaultsCreatedWhenCompanyCreatedTest < ActionDispatch::IntegrationTest

  def setup
    @app_admin = auth_users(:app_admin_user)
    @company_admin = auth_users(:company_admin_user)

    @company_hash = {
      name: "Test Company Defaults Created",
      company_type: "warehouse"
    }
  end

  def create_company_as(user, parameter, validity)
    log_in_if_user(user)
    params = { company: parameter }
    if validity == true
      assert_difference 'Company.count', 1 do
        post companies_path, xhr: true, params: params
      end
      return Company.last
    else
      assert_no_difference 'Company.count' do
        post companies_path, xhr: true, params: params
      end
      return nil
    end
  end

  test "when a new warehouse company is created, defaults are correct" do
    company = create_company_as(@app_admin, @company_hash, true)
    assert !company.nil?
    # Check that the defaults are correct
    assert !DockGroup.find_by(company_id: company.id).nil?
    assert !AccessPolicy.find_by(company_id: company.id).nil?
  end

  test "when a new shipper company is created, defaults are correct" do
    @company_hash[:company_type] = "shipper"
    company = create_company_as(@app_admin, @company_hash, true)
    assert !company.nil?
    # Check that the defaults are correct
    assert DockGroup.find_by(company_id: company.id).nil?
    assert !AccessPolicy.find_by(company_id: company.id).nil?
  end

  test "when a new admin company is created, defaults are correct" do
    @company_hash[:company_type] = "admin"
    company = create_company_as(@app_admin, @company_hash, true)
    assert !company.nil?
    # Check that the defaults are correct
    assert DockGroup.find_by(company_id: company.id).nil?
    assert !AccessPolicy.find_by(company_id: company.id).nil?
  end

end
