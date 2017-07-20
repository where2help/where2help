$(document).ready () ->
  $('a[data-turbolinks="false"]').click (e) ->
    if $(this).hasClass('nav-help-now')
      href = $(this).get(0).hash
    else
      href = $(this).attr('href')

    if(href.charAt(0) == '#')
      e.preventDefault()
      $('html, body').animate({
        scrollTop: $(href).offset().top
      }, 500)

  $(window).scroll () ->
    logo = $('.main-logo').get(0)
    if logo
      rect = logo.getBoundingClientRect();
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

