function removeRecord(target) {
  $(target).fadeOut(500, function(){
    $(this).remove();
  });
}

function replaceRecord(target, content) {
  $(target).replaceWith(content);
}

function appendRecord(target, content) {
  $(target).append(content);
}

function prependRecord(target, content) {
  $(target).prepend(content);
}
