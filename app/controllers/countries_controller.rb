class CountriesController < ApplicationController

  def states
    skip_authorization
    states = Geography.states_for_country(params[:id])
    respond_to do |format|
       format.json { render json: states.to_json }
    end
  end

end
