require 'test_helper'
require 'pp'

class DefaultsCreatedWhenCompanyCreatedTest < ActionDispatch::IntegrationTest

  def setup
    @app_admin = users(:app_admin_user)
    @company_admin = users(:company_admin_user)
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

  company_hash = { name: "Test Company Defaults Created" }

  test "when a new company is created, default things are created as well" do
    company = create_company_as(@app_admin, company_hash, true)
    assert !company.nil?
    # Check that the default dock group is created.
    default_dock_group = DockGroup.find_by(company_id: company.id)
    assert !default_dock_group.nil?
    assert_match "Default", default_dock_group.description
  end

end
