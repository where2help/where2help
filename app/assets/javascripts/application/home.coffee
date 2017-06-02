$(document).ready () ->
  $(window).scroll () ->
    rect = $('.main-logo').get(0).getBoundingClientRect();
    isBigLogoStillVisible = (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );

    if isBigLogoStillVisible
      $('.navbar-brand').removeClass('passed-header')
    else
      $('.navbar-brand').addClass('passed-header')

