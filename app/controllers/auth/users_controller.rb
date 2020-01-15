class Auth::UsersController < ApplicationController
    include FormHelper, ModalHelper, PageHelper

    def new
      form = new_form_prep_record(Auth::UserNewCreateForm)
      authorize form.record
      form.setup_variables
      modal = Modal::NewModal.new(form)
      render_modal(modal)
    end

    def create
      form = new_form_prep_record(Auth::UserNewCreateForm)
      assign_form_attributes(form)
      authorize form.record
      form.submit
      form.setup_variables
      modal = Modal::CreateModal.new(form, table: form.table)
      render_modal(modal)
    end

    def edit
      form = new_form_prep_record(Auth::UserEditUpdateForm)
      authorize form.record
      form.setup_variables
      modal = Modal::EditModal.new(form)
      render_modal(modal)
    end

    def update
      form = new_form_prep_record(Auth::UserEditUpdateForm)
      assign_form_attributes(form)
      authorize form.record
      form.submit
      form.setup_variables
      modal = Modal::UpdateModal.new(form, table: form.table)
      render_modal(modal)
    end

    def index
      page = new_page_prep_records(Page::IndexListPage)
      page.table = Table::Auth::UsersIndexTable.new(current_user)
      authorize_scope_records(page)
      pagy_records(page)
      render_page(page)
    end

end
