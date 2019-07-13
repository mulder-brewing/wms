function remove(target_for_jquery) {
  $(target_for_jquery).fadeOut(500, function(){
    $(this).remove();
  });
}
