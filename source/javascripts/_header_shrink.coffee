header = $('.header-sticky')

resizeHeader = _.throttle ->
  if $(window).scrollTop() > 100
    header.addClass('header-fixed-shrink')
  else
    header.removeClass('header-fixed-shrink')
, 100

$(window).scroll(resizeHeader)
resizeHeader()
