function showResetPassword() {
  if ( $("div.password").hasClass("form-group-invalid") || $("div.auth_user_password_confirmation").hasClass("form-group-invalid") || $("input#auth_user_send_email").hasClass("is-invalid") ) {
      $("#collapseResetPassword").addClass("show");
  }
}
