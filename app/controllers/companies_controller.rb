class CompaniesController < ApplicationController
  def new
    @company = Company.new

    respond_to do |format|
        format.html
        format.js
    end
  end

  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @company = Company.new(company_params)    # Not the final implementation!

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, :flash => { :success => "Company successfully created!" } }
        format.js
      else
        format.html { render 'new' }
        format.js
      end
    end
  end

  def index
    @companies = Company.all
    @company = Company.new
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, :flash => { :success => "Company successfully deleted!" } }
      format.js
    end
  end

  def destroy_modal
    @company = Company.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @company = Company.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(company_params)
      respond_to do |format|
        format.html { redirect_to companies_url, :flash => { :success => "Company successfully updated!" } }
        format.js
      end
    else
      respond_to do |format|
        format.html
        format.js
      end
    end

  end

  private

    def company_params
      params.require(:company).permit(:name)
    end
end
