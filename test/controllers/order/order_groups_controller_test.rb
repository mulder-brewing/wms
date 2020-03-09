require 'test_helper'

class Order::OrderGroupsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @record_1 = order_order_groups(:default)
    @other_record_1 = order_order_groups(:other)

    @other_admin = auth_users(:other_company_admin)
    @everything_ap_user = auth_users(:everything_ap_user)
    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_shipper_admin = auth_users(:everything_ap_shipper_company_admin)
    @nothing_ap_shipper_admin = auth_users(:nothing_ap_shipper_company_admin)

    @new = Order::OrderGroup.new
    @form = Order::OrderGroupForm

    @update_fields = [:description, :enabled]

    @ph = { :description => "Default" }
    @phu = { :description => "Updated for test", :enabled => false }
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "nothing ap user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "everything ap user can see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, true)
    to.query = :enabled
    to.test(self)
  end

  test "everything ap(disabled) user can't see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.query = :enabled
    to.test(self)
  end

  test "order groups ap user can see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.query = :enabled
    to.test(self)
  end

  test "order groups ap(disabled) user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.query = :enabled
    to.test(self)
  end

  test "everything ap shipper user can't see the link" do
    to = NavbarTO.new(@everything_ap_shipper_admin, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "order groups ap shipper user can't see the link" do
    to = NavbarTO.new(@nothing_ap_shipper_admin, @new, false)
    to.enable_model_permission
    to.query = :enabled
    to.test(self)
  end
end
