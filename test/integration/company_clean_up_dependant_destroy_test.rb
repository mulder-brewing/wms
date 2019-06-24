require 'test_helper'

class CompanyCleanUpDependantDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @company_to_delete = companies(:company_to_delete)
    @delete_me_user = users(:delete_me_user)
    @delete_me_dock_group = dock_groups(:delete_me_dock_group)
  end

  test "deleting a company cleans up all the dependent destroys" do
    @company_to_delete.destroy
    assert !Company.exists?(@company_to_delete.id)
    assert !User.exists?(@delete_me_user.id)
    assert !DockGroup.exists?(@delete_me_dock_group.id)
  end
end
