// Show error flash when devise returns 401 for js request
$(document).ajaxError(function (e, xhr, settings) {
    if (xhr.status == 401) {
      $('main:first-child').prepend("<div class=\"alert alert-danger alert-dismissable\"><button name=\"button\" type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>" + xhr.responseText + "</div>");
      $('html,body').animate({scrollTop: 0}, 750);
    }
});
