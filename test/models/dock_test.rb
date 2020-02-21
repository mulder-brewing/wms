require 'test_helper'

class DockTest < ActiveSupport::TestCase
  def setup
    # Docks
    @average_joe_dock = docks(:average_joe_dock)
    @other_dock = docks(:other_dock)
    @delete_me_dock = docks(:delete_me_dock)

    # Dock Groups
    @other_company_dg = dock_groups(:other_company)

    # Companies
    @other_company = companies(:other_company)
  end

  def invalid?
    !@average_joe_dock.valid?
  end

  def valid?
    @average_joe_dock.valid?
  end

  test "average joe dock is valid" do
    pp @average_joe_dock.valid?
    pp @average_joe_dock.errors.full_messages
    assert valid?

  end

  test "average joe dock is invalid when number is blank or nil" do
    @average_joe_dock.number = ""
    assert invalid?
    @average_joe_dock.number = nil
    assert invalid?
  end

  test "docks within the same group can't have the same number" do
    @dock2 = @average_joe_dock.dup
    assert !@dock2.valid?
    @dock2.number = "some other number"
    assert @dock2.valid?
  end

  test "docks in different groups can have the same number" do
    @average_joe_dock.number = @other_dock.number
    assert valid?
  end

  test "a dock number must be 50 characters or less" do
    @average_joe_dock.number = "a" * 51
    assert invalid?
    @average_joe_dock.number = "a" * 50
    assert valid?
  end

  test "average joe dock is invalid with company_id that doesn't exit" do
    company_id = 9999999
    company = Company.find_by(id: company_id)
    assert_nil company
    @average_joe_dock.company_id = company_id
    assert invalid?
  end

  test "average joe dock is invalid without a company_id" do
    @average_joe_dock.company_id = ""
    assert invalid?
    @average_joe_dock.company_id = nil
    assert invalid?
  end

  test "average joe dock is invalid if the company_id doesn't match the dock group's company_id" do
    @average_joe_dock.company_id = @other_company.id
    assert invalid?
  end

  test "average joe dock is invalid if the company of the dock group doesn't match the company of the dock" do
    @average_joe_dock.dock_group_id = @other_company_dg.id
    assert invalid?
  end

  test "average joe dock must have a dock_group_id" do
    @average_joe_dock.dock_group_id = ""
    assert invalid?
    @average_joe_dock.dock_group_id = nil
    assert invalid?
  end

  test "average joe dock is invalid with dock_group_id that doesn't exist" do
    dock_group_id = 9999999
    dock_group = DockGroup.find_by(id: dock_group_id)
    assert_nil dock_group
    @average_joe_dock.dock_group_id = dock_group_id
    assert invalid?
  end

end
