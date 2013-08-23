jQuery ->
# jQuery(window).load ->
  @film_rolls ||= []
  @film_rolls['film_roll_1'] = new FilmRoll {container: '#film_roll_1', height: 560, pager: true}
  @film_rolls['film_roll_2'] = new FilmRoll {container: '#film_roll_2', height: 190, prev: '#film_roll_2_left', next: '#film_roll_2_right'}
  @film_rolls['film_roll_3'] = new FilmRoll {container: '#film_roll_3', height: 190, pager: false}
  true