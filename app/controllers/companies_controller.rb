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
    @company = Company.find_by(id: params[:id])
    respond_to :js
  end

  def edit
    @company = Company.find_by(id: params[:id])
    respond_to :js
  end

  def update
    @company = Company.find(params[:id])
    @company.update_attributes(company_params)
    respond_to :js
  end

  def destroy_modal
    @company = Company.find_by(id: params[:id])
    respond_to :js
  end

  def destroy
    @company = Company.find(params[:id])
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
      redirect_to(root_url) unless current_user.app_admin?
    end
end
