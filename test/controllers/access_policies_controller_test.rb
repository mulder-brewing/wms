require 'test_helper'

class AccessPoliciesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_admin = auth_users(:other_company_admin)

    @new = AccessPolicy.new
    @form = AccessPolicyForm

    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)
    @averagejoe_access_policy_nothing = access_policies(:average_joe_access_policy_nothing)
    @other_access_policy = access_policies(:other_access_policy_everything)

    @ph = { description: "New AP Description" }
    @phu = { description: "Updated Description", enabled: false,
      everything: false, dock_groups: false, docks: false }
    @update_fields = [:description, :enabled, :everything, :dock_groups, :docks]
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
    to.visibles << NewModalTitleVisible.new(model_class: AccessPolicy)
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
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
    to.visibles << EditModalTitleVisible.new(model_class: AccessPolicy)
    to.test(self)
  end

  test "edit modal save and close buttons" do
    to = EditTO.new(@company_admin, @averagejoe_access_policy, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
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

  # ----------------------------------------------------------------------------
  # Tests for updating a record.

  test "company admin can update record" do
    to = UpdateTO.new(@company_admin, @averagejoe_access_policy, @phu, true)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a logged out user can't update record" do
    to = UpdateTO.new(nil, @averagejoe_access_policy, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "regular user can't update record" do
    to = UpdateTO.new(@regular_user, @averagejoe_access_policy, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "company admin can't update record in other company" do
    to = UpdateTO.new(@company_admin, @other_access_policy, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  test "company admin can index and see only own company records" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy)
    to.visibles << IndexTRecordVisible.new(record: @other_access_policy, visible: false)
    to.test(self)
  end

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "a regular user can't index" do
    IndexTo.new(@regular_user, @new, false).test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexRecordsTitleVisible.new(model_class: AccessPolicy)
    to.test(self)
  end

  test "page should have new record button" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name)
    to.test(self)
  end

  test "should see the edit buttons" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::IndexEditButton.class_name)
    to.test(self)
  end

  test "page should have enabled filter" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << EnabledFilterVisible.new
    to.test(self)
  end

  test "should see both enabled and disabled with all filter." do
    to = IndexTo.new(@company_admin, @new, true)
    @averagejoe_access_policy_nothing.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy)
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy_nothing)
    to.test(self)
  end

  test "should only see enabled with enabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :enabled
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy)
    @averagejoe_access_policy_nothing.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy_nothing, visible: false)
    to.test(self)
  end

  test "should only see disabled with disabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :disabled
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy, visible: false)
    @averagejoe_access_policy_nothing.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @averagejoe_access_policy_nothing)
    to.test(self)
  end


end
