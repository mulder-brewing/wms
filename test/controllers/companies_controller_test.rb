require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @app_admin = auth_users(:app_admin_user)

    @averagejoes = companies(:averagejoes)

    @new = Company.new
    @form = CompanyForm

    types = Company.company_types
    @ph = { name: "Test Company A", company_type: types[:warehouse], legitimate: true}
    @pu = { name: "Updated", company_type: types[:shipper], legitimate: false, enabled: false }

    @update_fields = [:name, :company_type, :legitimate, :enabled]
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "app admin can see the link" do
    to = NavbarTO.new(@app_admin, @new, true)
    to.query = :enabled
    to.test(self)
  end

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

  test "company admin can't see the link" do
    to = NavbarTO.new(@company_admin, @new, false)
    to.query = :enabled
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for new modal.

  test "app admin can get new company modal" do
    NewTO.new(@app_admin, @new, true).test(self)
  end

  test "app admin field visibility new modal" do
    to = NewTO.new(@app_admin, @new, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :name)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_type)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "new modal title" do
    to = NewTO.new(@app_admin, @new, true)
    to.visibles << NewModalTitleVisible.new(model_class: Company)
    to.test(self)
  end

  test "logged out can't get new modal" do
    NewTO.new(nil, @new, false).test(self)
  end

  test "regular user can't get new modal" do
    NewTO.new(@regular_user, @new, false).test(self)
  end

  test "company admin can't get new modal" do
    NewTO.new(@company_admin, @new, false).test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  test "app admin can create" do
    to = CreateTO.new(@app_admin, @new, true, params_hash: @ph)
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@app_admin, @new, true, params_hash: @ph)
    to.attributes = { :enabled => true }
    to.test(self)
  end

  test "logged out can't create" do
    to = CreateTO.new(nil, @new, false, params_hash: @ph)
    to.test(self)
  end

  test "regular user can't create" do
    to = CreateTO.new(@regular_user, @new, false, params_hash: @ph)
    to.test(self)
  end

  test "company admin can't create" do
    to = CreateTO.new(@company_admin, @new, false, params_hash: @ph)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "app admin can get edit modal" do
    EditTO.new(@app_admin, @averagejoes, true).test(self)
  end

  test "app admin field visibility" do
    to = EditTO.new(@app_admin, @averagejoes, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :name)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_type)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled)
    to.test(self)
  end

  test "edit modal title" do
    to = EditTO.new(@app_admin, @averagejoes, true)
    to.visibles << EditModalTitleVisible.new(model_class: Company)
    to.test(self)
  end

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @averagejoes, false).test(self)
  end

  test "regular user can't get edit modal" do
    EditTO.new(@regular_user, @averagejoes, false).test(self)
  end

  test "company admin can't get edit modal" do
    EditTO.new(@company_admin, @averagejoes, false).test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  test "app admin can update record" do
    to = UpdateTO.new(@app_admin, @averagejoes, true, params_hash: @pu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "logged out can't update record" do
    to = UpdateTO.new(nil, @averagejoes, false, params_hash: @pu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "regular user can't update record" do
    to = UpdateTO.new(@regular_user, @averagejoes, false, params_hash: @pu)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "company admin can't update record" do
    to = UpdateTO.new(@company_admin, @averagejoes, false, params_hash: @pu)
    to.update_fields = @update_fields
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  test "app admin can index" do
    IndexTo.new(@app_admin, @new, true).test(self)
  end

  test "should see the new button" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name)
    to.test(self)
  end

  test "should see title" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << IndexRecordsTitleVisible.new(model_class: Company)
    to.test(self)
  end

  test "should see the edit and delete buttons" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::IndexEditButton.class_name)
    to.visibles << IndexTBodyVisible.new(class: Button::IndexDeleteButton.class_name)
    to.test(self)
  end

  test "pagination is there" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << PaginationVisible.new
    to.test(self)
  end

  test "enabled filter is visible" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << EnabledFilterVisible.new
    to.test(self)
  end

  test "enabled filter has the right links" do
    to = IndexTo.new(@app_admin, @new, true)
    to.test(self)
    verify_enabled_filter_links(to)
  end

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "regular user can't index" do
    IndexTo.new(@regular_user, @new, false).test(self)
  end

  test "company admin can't index" do
    IndexTo.new(@company_admin, @new, false).test(self)
  end



  # ----------------------------------------------------------------------------
  # Tests for delete modal

  test "app admin can get destroy modal" do
    to = ModalTO.new(@app_admin, @averagejoes, true)
    to.path = destroy_modal_company_path(@averagejoes)
    to.test(self)
  end

  test "destroy chicken message is there" do
    to = ModalTO.new(@app_admin, @averagejoes, true)
    to.path = destroy_modal_company_path(@averagejoes)
    to.visibles << DestroyMessageVisible.new(to_delete: @averagejoes.name)
    to.test(self)
  end

  test "destroy modal title" do
    to = ModalTO.new(@app_admin, @averagejoes, true)
    to.path = destroy_modal_company_path(@averagejoes)
    to.visibles << DestroyModalTitleVisible.new(model_class: Company)
    to.test(self)
  end

  test "should see the delete and close buttons" do
    to = ModalTO.new(@app_admin, @averagejoes, true)
    to.path = destroy_modal_company_path(@averagejoes)
    to.visibles << ModalFooterVisible.new(class: Button::ModalDeleteButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "logged out can't get destroy modal" do
    to = ModalTO.new(nil, @averagejoes, false)
    to.path = destroy_modal_company_path(@averagejoes)
    to.test(self)
  end

  test "regular user can't get destroy modal" do
    to = ModalTO.new(@regular_user, @averagejoes, false)
    to.path = destroy_modal_company_path(@averagejoes)
    to.test(self)
  end

  test "company admin can't get destroy modal" do
    to = ModalTO.new(@company_admin, @averagejoes, false)
    to.path = destroy_modal_company_path(@averagejoes)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for deleting record

  test "app admin can delete a company" do
    DestroyTO.new(@app_admin, @averagejoes, true).test(self)
  end

  test "logged out user can't delete a company" do
    DestroyTO.new(nil, @averagejoes, false).test(self)
  end

  test "regular user can't delete a company" do
    DestroyTO.new(@regular_user, @averagejoes, false).test(self)
  end

  test "company admin can't delete a company" do
    DestroyTO.new(@company_admin, @averagejoes, false).test(self)
  end

end
