function showResetPassword() {
  if ( $("div.password").hasClass("form-group-invalid") || $("div.user_password_confirmation").hasClass("form-group-invalid") || $("input#user_send_email").hasClass("is-invalid") ) {
      $("#collapseResetPassword").addClass("show");
  }
}
