function removeRecord(target) {
  $(target).fadeOut(500, function(){
    $(this).remove();
  });
}

function replaceRecord(target, content) {
  $(target).replaceWith(content);
  fadeInRecord(target);
}

function appendRecord(target, content, id) {
  $(target).append(content);
  fadeInRecord(id);
}

function prependRecord(target, content, id) {
  $(target).prepend(content);
  fadeInRecord(id);
}

function fadeInRecord(target) {
  $(target).hide().fadeIn(500);
}
