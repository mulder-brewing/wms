class CompaniesController < ApplicationController
  before_action :app_admin

  def new
    @company = Company.new
    respond_to :js
  end

  def create
    @company = Company.new(company_params)
    @company.save
    respond_to :js
  end

  def show
    find_company_by_id
    respond_to :js
  end

  def edit
    find_company_by_id
    respond_to :js
  end

  def update
    find_company_by_id
    @company.update(company_params)
    respond_to :js
  end

  def destroy_modal
    find_company_by_id
    respond_to :js
  end

  def destroy
    find_company_by_id
    @company.destroy
    respond_to :js
  end

  def index
    @pagy, @companies = pagy(Company.all.order(:name), items:25)
  end

  private
    def company_params
      params.require(:company).permit(:name, :enabled)
    end

    def app_admin
      all_formats_redirect_to(root_url) unless logged_in_app_admin?
    end

    def find_company_by_id
      @company = Company.find_by(id: params[:id])
    end
end
