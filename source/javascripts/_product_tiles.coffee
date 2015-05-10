tiles = $('.product-tiles').isotope();

$('.product-tile-filters').on 'change', 'input', ->
  tiles.isotope({ filter: $(this).val() })
