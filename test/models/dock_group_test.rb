require 'test_helper'

class DockGroupTest < ActiveSupport::TestCase
  def setup
    @cooler_dock_group = dock_groups(:cooler)
    @other_company = companies(:other_company)
  end

  def invalid?
    !@cooler_dock_group.valid?
  end

  def valid?
    @cooler_dock_group.valid?
  end

  test "a dock group without a description is invalid" do
    @cooler_dock_group.description = ""
    assert invalid?
    @cooler_dock_group.description = nil
    assert invalid?
  end

  test "a dock group without a company_id is invalid" do
    @cooler_dock_group.company_id = ""
    assert invalid?
    @cooler_dock_group.company_id = nil
    assert invalid?
  end

  test "a dock group with a company_id that doesn't exist is invalid" do
    @cooler_dock_group.company_id = 1000000
    assert invalid?
  end

  test "a dock group with a company_id that exists is valid" do
    assert valid?
    @cooler_dock_group.company_id = @other_company.id
    assert valid?
  end

  test "a dock group description must be 50 characters or less" do
    @cooler_dock_group.description = "a" * 50
    assert valid?
    @cooler_dock_group.description = "a" * 51
    assert invalid?
  end

  test "a dock group's description must be unique within the same company" do
    new_dock_group = @cooler_dock_group.dup
    assert !new_dock_group.valid?
    new_dock_group.company_id = @other_company.id
    assert new_dock_group.valid?
    new_dock_group.company_id = @cooler_dock_group.company_id
    new_dock_group.description = "Some Other Description"
    assert new_dock_group.valid?
  end



end
