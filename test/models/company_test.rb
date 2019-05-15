require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  def setup
    @company = Company.new(name: "Example Company")
    @other_company = Company.new(name: "Other Example Company")
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

end
