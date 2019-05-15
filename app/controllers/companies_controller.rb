class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def show
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(company_params)    # Not the final implementation!
    if @company.save
      flash[:success] = "Company successfully created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def company_params
      params.require(:company).permit(:name)
    end
end
