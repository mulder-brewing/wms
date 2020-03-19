export const MulderUtil = {

  replaceSelectOptions({ options, select_id, label_method, value_method = "id", please_select = true } ) {
    var select = $(select_id);
    select.empty();
    var append = '';
    append += `<option value>${please_select ? "Please select" : ""}</option>`
    if (MulderUtil.isIterable(options)) {
      for (var option of options) {
        append += selectOption({ value: option[value_method], label: option[label_method] })
      }
    } else {
      $.each(options, function(key, value){
        append += selectOption({ value: key, label: value })
      })
    }
    select.append(append)
  },

  isIterable(obj) {
    // checks for null and undefined
    if (obj == null) {
      return false;
    }
    return typeof obj[Symbol.iterator] === 'function';
  }
  
}

function selectOption({ value, label }) {
  return `<option value=${value}>${label}</option>`
}
