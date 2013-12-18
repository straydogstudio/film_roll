jQuery ->
  @film_rolls = new FilmRoll {container: '#film_roll', scroll: false}
  jQuery('a.more_link').click ->
    jQuery('#more').slideToggle()
