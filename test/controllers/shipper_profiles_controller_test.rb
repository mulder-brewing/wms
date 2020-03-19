require 'test_helper'

class ShipperProfilesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @record_1 = shipper_profiles(:shipper_profile)
    @disabled_record = shipper_profiles(:shipper_profile_disabled)
    @other_record_1 = shipper_profiles(:other)

    @shipper = companies(:shipper_company)
    @shipper_2 = companies(:shipper_company_2)
    @shipper_3 = companies(:shipper_company_3)
    @test_shipper = companies(:test_shipper)

    @other_admin = auth_users(:other_company_admin)
    @everything_ap_user = auth_users(:everything_ap_user)
    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_shipper_admin = auth_users(:everything_ap_shipper_company_admin)
    @nothing_ap_shipper_admin = auth_users(:nothing_ap_shipper_company_admin)

    @new = ShipperProfile.new
    @form = ShipperProfileForm

    @update_fields = [:enabled]

    @ph = { :shipper_id => @shipper_3.id }
    @phu = { :enabled => false }
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

  test "shipper profiles ap user can see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.query = :enabled
    to.test(self)
  end

  test "shipper profiles ap(disabled) user can't see the link" do
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

  test "shipper profiles ap shipper user can't see the link" do
    to = NavbarTO.new(@nothing_ap_shipper_admin, @new, false)
    to.enable_model_permission
    to.query = :enabled
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for new modal.

  test "logged out user can't get new modal" do
    to = NewTO.new(nil, @new, false)
    to.test(self)
  end

  test "a nothing ap user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.test(self)
  end

  test "a everything ap user can get new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.test(self)
  end

  test "a everything ap(disabled) user can't get new modal" do
    to = NewTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a shipper profiles ap user can get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a shipper profiles ap(disabled) user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap shipper user can't get new modal" do
    to = NewTO.new(@everything_ap_shipper_admin, @new, false)
    to.test(self)
  end

  test "a shipper profiles ap shipper user can't get new modal" do
    to = NewTO.new(@nothing_ap_shipper_admin, @new, false)
    to.enable_model_permission
    to.test(self)
  end

  test "new modal title" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << NewModalTitleVisible.new(model_class: ShipperProfile)
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "the enable/disable switch should not be visible on the new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "only shippers not yet added are in selector" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper.name,
      option_id: @shipper.id,
      visible: false
    )
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper_2.name,
      option_id: @shipper_2.id,
      visible: false
    )
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper_3.name,
      option_id: @shipper_3.id,
      visible: true
    )
    to.test(self)
  end

  test "disabled shipper not in selector" do
    to = NewTO.new(@everything_ap_user, @new, true)
    @shipper_3.update_column(:enabled, false)
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper_3.name,
      option_id: @shipper_3.id,
      visible: false
    )
    to.test(self)
  end

  test "test shipper not in selector for legitimate warehouse" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @test_shipper.name,
      option_id: @test_shipper.id,
      visible: false
    )
    to.test(self)
  end

  test "test shipper in selector for test warehouse" do
    to = NewTO.new(@everything_ap_user, @new, true)
    @everything_ap_user.company.update_column(:legitimate, false)
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @test_shipper.name,
      option_id: @test_shipper.id,
      visible: true
    )
    to.test(self)
  end

  test "other warehouse can see correct shippers in selector" do
    to = NewTO.new(@other_admin, @new, true)
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper.name,
      option_id: @shipper.id,
      visible: true
    )
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper_2.name,
      option_id: @shipper_2.id,
      visible: true
    )
    to.visibles << FormSelectOptionVisible.new(
      form: @form,
      field: :shipper_id,
      text: @shipper_3.name,
      option_id: @shipper_3.id,
      visible: false
    )
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  test "a logged out user can't create" do
    CreateTO.new(nil, @new, false, params_hash: @ph).test(self)
  end

  test "a nothing ap user can't create" do
    CreateTO.new(@nothing_ap_user, @new, false, params_hash: @ph).test(self)
  end

  test "a everything ap user can create" do
    CreateTO.new(@everything_ap_user, @new, true, params_hash: @ph).test(self)
  end

  test "a everything ap(disabled) user can't create" do
    to = CreateTO.new(@everything_ap_user, @new, false, params_hash: @ph)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a shipper profiles ap user can create" do
    to = CreateTO.new(@nothing_ap_user, @new, true, params_hash: @ph)
    to.enable_model_permission
    to.test(self)
  end

  test "a shipper profiles ap(disabled) user can't create" do
    to = CreateTO.new(@nothing_ap_user, @new, false, params_hash: @ph)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap shipper user can't create" do
    to = CreateTO.new(@everything_ap_shipper_admin, @new, false, params_hash: @ph)
    to.test(self)
  end

  test "a shipper profiles ap shipper user can't create" do
    to = CreateTO.new(@nothing_ap_shipper_admin, @new, false, params_hash: @ph)
    to.enable_model_permission
    to.test(self)
  end

  test "Create with other company id will still save with user's company id" do
    to = CreateTO.new(@everything_ap_user, @new, true, params_hash: @ph)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.attributes = { :company_id => @everything_ap_user.company_id }
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@everything_ap_user, @new, true, params_hash: @ph)
    to.attributes = { :enabled => true }
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @record_1, false).test(self)
  end

  test "a nothing ap user can't get edit modal" do
    EditTO.new(@nothing_ap_user, @record_1, false).test(self)
  end

  test "a everything ap user can get the edit modal" do
    EditTO.new(@everything_ap_user, @record_1, true).test(self)
  end

  test "a everything ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a shipper profiles ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a shipper profiles ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    EditTO.new(@everything_ap_user, @other_record_1, false).test(self)
  end

  test "edit modal title" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << EditModalTitleVisible.new(model_class: ShipperProfile)
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "edit modal timestamps are visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalTimestampsVisible.new
    to.test(self)
  end

  test "the enable/disable switch should be visible on the edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled)
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  test "a logged out user can't update" do
    to = UpdateTO.new(nil, @record_1, false, params_hash: @phu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params_hash: @phu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap user can update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, true, params_hash: @phu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap(disabled) user can't update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params_hash: @phu)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a shipper profiles ap user can update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, true, params_hash: @phu)
    to.update_fields = @update_fields
    to.enable_model_permission
    to.test(self)
  end

  test "a shipper profiles ap(disabled) user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params_hash: @phu)
    to.update_fields = @update_fields
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't update other company's record" do
    to = UpdateTO.new(@everything_ap_user, @other_record_1, false, params_hash: @phu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, nil, params_hash: @phu)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "a nothing ap user can't index" do
    IndexTo.new(@nothing_ap_user, @new, false).test(self)
  end

  test "a everything ap user can index and only see own records" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << IndexTRecordVisible.new(record: @record_1)
    to.visibles << IndexTRecordVisible.new(record: @other_record_1, visible: false)
    to.test(self)
  end

  test "a everything ap(disabled) user can't index" do
    to = IndexTo.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a shipper profiles ap user can index" do
    to = IndexTo.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a shipper profiles ap(disabled) user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap shipper user can't index" do
    IndexTo.new(@everything_ap_shipper_admin, @new, false).test(self)
  end

  test "a shipper profiles ap shipper user can't index" do
    to = IndexTo.new(@nothing_ap_shipper_admin, @new, false)
    to.enable_model_permission
    to.test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << IndexRecordsTitleVisible.new(model_class: ShipperProfile)
    to.test(self)
  end

  test "page should have new record button" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name)
    to.test(self)
  end

  test "should see the edit buttons" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::IndexEditButton.class_name)
    to.test(self)
  end

  test "page should have enabled filter" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << EnabledFilterVisible.new
    to.test(self)
  end

  test "should see both enabled and disabled with all filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << IndexTRecordVisible.new(record: @record_1)
    to.visibles << IndexTRecordVisible.new(record: @disabled_record)
    to.test(self)
  end

  test "should only see enabled with enabled filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = :enabled
    to.visibles << IndexTRecordVisible.new(record: @record_1)
    to.visibles << IndexTRecordVisible.new(record: @disabled_record, visible: false)
    to.test(self)
  end

  test "should only see disabled with disabled filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = :disabled
    to.visibles << IndexTRecordVisible.new(record: @record_1, visible: false)
    to.visibles << IndexTRecordVisible.new(record: @disabled_record)
    to.test(self)
  end

  test "pagination is there" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.visibles << PaginationVisible.new
    to.test(self)
  end

end