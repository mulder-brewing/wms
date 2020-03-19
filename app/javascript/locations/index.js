import { Ajax } from "ajax"

$( document ).on('show.bs.modal', function () {
  if ($('body.locations.index').length > 0) {
    locationCountryStates()
  }
})

// Change available states depending on which country is selected.
function locationCountryStates() {
  var $country = $("#location_country:not(.bound)")
  $country.addClass("bound").on("change", function(){
    Ajax.replaceSelectOptions(
      { url: `countries/${$country.val()}/states`,
        select_options: {
          select_id: "#location_state"
        }
      }
    )
  })
}
