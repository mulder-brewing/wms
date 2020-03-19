import { MulderUtil } from "mulder_util"

export const Ajax = {

  replaceSelectOptions({  url,
                          data = null,
                          response_function = null,
                          select_options }) {
    $.ajax({
      url: url,
      method: "GET",
      dataType: "json",
      data: data,
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error)
      },
      success: function (response) {
        select_options.options = response_function != null ? response_function(response) : response
        MulderUtil.replaceSelectOptions(select_options)
      }
    })
  }

}
