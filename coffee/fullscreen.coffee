jQuery ->
  @film_rolls = new FilmRoll {container: '#film_roll', scroll: false, vertical_center: true}
  jQuery('a.more_link').click ->
    jQuery('#more').slideToggle()
