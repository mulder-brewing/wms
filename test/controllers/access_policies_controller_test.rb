require 'test_helper'

class AccessPoliciesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_admin = auth_users(:other_company_admin)

    @new = AccessPolicy.new
    @form = AccessPolicyForm

    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)
    @other_access_policy = access_policies(:other_access_policy_everything)

    @ph = { description: "New AP Description" }
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "regular user can't see the link" do
    to = NavbarTO.new(@regular_user, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "company admin can see the link" do
    to = NavbarTO.new(@company_admin, @new, true)
    to.query = :enabled
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for new modal.

  test "logged out user can't get new modal" do
    NewTO.new(nil, @new, false).test(self)
  end

  test "a regular user can't get new modal" do
    NewTO.new(@regular_user, @new, false).test(self)
  end

  test "a company admin can get new modal" do
    NewTO.new(@company_admin, @new, true).test(self)
  end

  test "company admin field visibility new modal" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :description)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :everything)
    to.visibles << FormFieldVisible.new(form: @form, field: :dock_groups)
    to.visibles << FormFieldVisible.new(form: @form, field: :docks)
    to.test(self)
  end

  test "new modal title" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalTitleVisible.new(text: "access_policies.title.new_create")
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalFooterVisible.new(class: Button::SaveButton::BTN_CLASS)
    to.visibles << ModalFooterVisible.new(class: Button::CloseButton::BTN_CLASS)
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  test "a logged out user can't create" do
    CreateTO.new(nil, @new, @ph, false).test(self)
  end

  test "a regular user can't create" do
    CreateTO.new(@regular_user, @new, @ph, false).test(self)
  end

  test "a company admin can create" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
  end

  test "company admin can only create own company record" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.attributes = { :company_id => @company_admin.company_id }
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.attributes = { :enabled => true }
    to.test(self)
  end

  test "description must be unique within company" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
    to = CreateTO.new(@company_admin, @new, @ph, false)
    to.visibles << FormErrorVisible.new(field: :description, type: :unique)
    to.test(self)
  end

  test "description can be the same for other company" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
    CreateTO.new(@other_admin, @new, @ph, true).test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @averagejoe_access_policy, false).test(self)
  end

  test "regular user can't get edit modal" do
    EditTO.new(@regular_user, @averagejoe_access_policy, false).test(self)
  end

  test "company admin can get edit modal" do
    EditTO.new(@company_admin, @averagejoe_access_policy, true).test(self)
  end

  test "company admin can't edit other company record" do
    EditTO.new(@company_admin, @other_access_policy, false).test(self)
  end

  test "edit modal title" do
    to = EditTO.new(@company_admin, @averagejoe_access_policy, true)
    to.visibles << ModalTitleVisible.new(text: "access_policies.title.edit_update")
    to.test(self)
  end

  test "edit modal save and close buttons" do
    to = EditTO.new(@company_admin, @averagejoe_access_policy, true)
    to.visibles << ModalFooterVisible.new(class: Button::SaveButton::BTN_CLASS)
    to.visibles << ModalFooterVisible.new(class: Button::CloseButton::BTN_CLASS)
    to.test(self)
  end

  test "edit modal timestamps are visible" do
    to = EditTO.new(@company_admin, @averagejoe_access_policy, true)
    to.visibles << ModalTimestampsVisible.new
    to.test(self)
  end

  test "company admin field visibility" do
    to = EditTO.new(@company_admin, @averagejoe_access_policy, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :description)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled)
    to.visibles << FormFieldVisible.new(form: @form, field: :everything)
    to.visibles << FormFieldVisible.new(form: @form, field: :dock_groups)
    to.visibles << FormFieldVisible.new(form: @form, field: :docks)
    to.test(self)
  end

end
