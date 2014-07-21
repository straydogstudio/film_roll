jQuery ->
  @film_rolls ||= []
  @film_rolls['film_roll_1'] = new FilmRoll {container: '#film_roll_1', height: '+10'}
  @film_rolls['film_roll_2'] = new FilmRoll {container: '#film_roll_2', height: 190, prev: '#film_roll_2_left', next: '#film_roll_2_right'}
  $('#film_roll_2').on 'film_roll:moving', ->
    setTimeout ->
      $('#film_roll_2 div.film_roll_shuttle').removeClass('moving_left moving_right')
    , 550
  @film_rolls['film_roll_3'] = new FilmRoll {container: '#film_roll_3', height: 190, pager: false}
  # fr = @film_rolls['film_roll_1']
  # $('#film_roll_1').swipe {
  #   swipeStatus: (event, phase, direction, distance) ->
  #     if direction == 'up' or direction == 'down'
  #       return false
  #     if phase == 'start'
  #       fr.was_scrolled = fr.scrolled
  #       if fr.scrolled
  #         fr.clearScroll()
  #       fr.active_half = fr.child_widths[fr.index]/2
  #       rotation_index = $.inArray fr.children[fr.index], fr.rotation
  #       fr.offscreen_left = parseInt(fr.shuttle.css('left'),10)
  #       fr.offscreen_right = fr.marginRight(rotation_index) - (fr.wrapper.width() - fr.child_widths[fr.index])/2
  #       fr.distances = []
  #       fr.times = []
  #     else if phase == 'move'
  #       if direction == 'left'
  #         # do we need to advance
  #         if distance > fr.active_half
  #           $(fr.children[fr.index]).removeClass('active')
  #           fr.index = (fr.index + 1) % fr.children.length
  #           $(fr.children[fr.index]).addClass('active')
  #           fr.active_half += fr.child_widths[fr.index]
  #         # do we need to rotate
  #         if distance > fr.offscreen_right
  #           fr.offscreen_left = fr.rotateLeft() + distance
  #           fr.offscreen_right += fr.childWidth(fr.rotation[fr.rotation.length-1])
  #         fr.shuttle.css 'left', fr.offscreen_left - distance
  #       else
  #         # do we need to advance
  #         if distance > fr.active_half
  #           $(fr.children[fr.index]).removeClass('active')
  #           fr.index -= 1
  #           if fr.index < 0
  #             fr.index = fr.children.length - 1
  #           $(fr.children[fr.index]).addClass('active')
  #           fr.active_half += fr.child_widths[fr.index]
  #         # do we need to rotate
  #         if distance + fr.offscreen_left > 0
  #           fr.offscreen_left = fr.rotateRight() - distance
  #         fr.shuttle.css 'left', fr.offscreen_left + distance
  #       fr.distances.push distance
  #       fr.times.push (new Date()).getTime()
  #     else
  #       if phase == 'end'
  #         console.log 'end'
  #         if fr.distances.length > 1
  #           distances = fr.distances.slice(-4)
  #           times = fr.times.slice(-4)
  #           throw_distance = 500 * (distances[distances.length-1]-distances[0]) /
  #             (times[times.length-1]-times[0])
  #           console.log fr.distances.slice(-4)
  #           console.log fr.times.slice(-4)
  #           console.log (distances[distances.length-1]-distances[0])
  #           console.log (times[times.length-1]-times[0])
  #           console.log throw_distance
  #           offset = fr.child_widths[fr.index]/2
  #           index = fr.index
  #           while offset < distance
  #             if direction == 'left'
  #               index = (index + 1) % fr.children.length
  #               offset += fr.child_widths[index]
  #             else
  #               index -= 1
  #               if index < 0
  #                 index = children.length - 1
  #               offset += fr.child_widths[index]
  #           easing = fr.easing
  #           fr.easing = 'easeOutSine'
  #           if typeof $.easing.easeOutSine == 'undefined'
  #             $.easing.easeOutSine = (x, t, b, c, d) ->
  #               return c * Math.sin(t/d * (Math.PI/2)) + b;
  #           fr.moveToIndex(index, direction)
  #           fr.easing = easing
  #         else
  #           fr.moveToIndex(fr.index, direction)
  #       else if phase == 'cancel'
  #         fr.moveToIndex(fr.index, (if direction == 'right' then 'left' else 'right'))
  #       if fr.was_scrolled
  #         fr.configureScroll()
  #       fr.distances = []
  #       fr.times = []
  #     true
  #   ,
  #   allowPageScroll: 'vertical'
  # }
  true