require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = Company.new(name: "Example Company")
    @other_company = Company.new(name: "Other Example Company")
    @delete_company = companies(:company_to_delete)
    @delete_user = users(:delete_me_user)
  end

  test "should be valid" do
    assert @company.valid?
  end

  test "Company with blank or nil name should be invalid" do
    @company.name = ""
    assert_not @company.valid?
    @company.name = nil
    assert_not @company.valid?
  end

  test "Company name should be 50 characters or less" do
    @company.name = "a"*50
    assert @company.valid?
    @company.name = "a"*51
    assert_not @company.valid?
  end

  test "Company name should be unique irregardless of case" do
    @company.name = "duplicate"
    @company.save
    @other_company.name = "duplicate"
    assert_not @other_company.valid?
    @other_company.name = "DupLicAtE"
    assert_not @other_company.valid?
  end

  test "Whitespace should be stripped from front and end of company name." do
    @company.name = "     Name     "
    @company.save
    assert @company.reload.name = "Name"
    @company.name = "  /t   Name   /n  "
    @company.save
    assert @company.reload.name = "Name"
  end

  test "Deleteing a company should also delete it's users because of dependent destroy" do
    @delete_company.destroy
    assert User.find_by(id: @delete_user.id).nil?
  end

end
