module LocationsHelper

  def states(form)
    HashUtil.to_select(
      Geography.states_for_country(selected_country(form))
    )
  end

  def countries
    HashUtil.to_select(Geography::COUNTRIES)
  end

  def selected_country(form)
    form.object.country || 'US'
  end
  
end
