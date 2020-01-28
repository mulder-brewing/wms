function alert_custom(type, message, secondary_msg = null) {
  secondary_msg = !secondary_msg ? '' : '<hr>' + secondary_msg;
  const html = [
    '<div id="alert-message" class="alert alert-' + type + ' alert-dismissible fixed-bottom fixed-alert high-z" role="alert">',
      '<strong>' + message + '</strong>',
      secondary_msg,
      '<button type="button" class="close" data-dismiss="alert" aria-label="Close">',
        '<span aria-hidden="true">&times;</span>',
      '</button>',
    '</div>'
  ].join("\n");
  $("#alert-wrapper").html(html);
  $("#alert-message").fadeTo(3000, 500).slideUp(500, function(){
    $(this).remove();
  });
}
