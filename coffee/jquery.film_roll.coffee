###
  FilmRoll (for jQuery)
  version: 0.1.0 (08/21/2013)
  @requires jQuery >= v1.4

  By Noel Peden
  Examples at http://film_roll.github.io

  Licensed under the MIT:
    http://www.opensource.org/licenses/mit-license.php

  Usage:
    var film_troll = new FilmRoll({container: '#container_id', OPTIONS});
###
class @FilmRoll

  constructor: (@options) ->
    @options = {} if @options is null
    if @options.container
      @div = jQuery @options.container
      @configure()

  configure: ->
    # add styling
    unless @options.no_css == true or document.film_roll_styles_added
      jQuery("<style type='text/css'>
        .film_roll_wrapper {display: block; text-align: center; float: none; position: relative; top: auto; right: auto; bottom: auto; left: auto; z-index: auto; width: 100%; margin: 0px; overflow: hidden; width: 100%}
        .film_roll_shuttle {text-align: left; float: none; position: absolute; top: 0; left:0; right: auto; bottom: auto; margin: 0px; z-index: auto}
        .film_roll_prev, .film_roll_next {position:absolute; top:48%; left:15px; width:40px; height:40px; margin:-20px 0 0 0; padding:0; font-size:60px; font-weight:100; line-height:30px; color:white; text-align: center; background: #222; border: 3px solid white; border-radius:23px; opacity:0.5}
        .film_roll_prev:hover, .film_roll_next:hover {color:white; text-decoration:none; opacity:0.9}
        .film_roll_next {left:auto; right:15px}
        .film_roll_pager {text-align:center}
        .film_roll_pager a {width:5px; height:5px; border:2px solid #333; border-radius:5px; display:inline-block; margin:0 5px 0 0}
        .film_roll_pager a:hover {background: #666}
        .film_roll_pager a.active {background: #333}
        .film_roll_pager span {display:none}
      </style>").appendTo('head')
      document.film_roll_styles_added = true

    # create divs for absolute positioning
    @children = @div.children()
    @children.wrapAll '<div class="film_roll_wrapper"></div>'
    @children.wrapAll '<div class="film_roll_shuttle"></div>'
    @wrapper = @div.find '.film_roll_wrapper'
    @shuttle = @div.find '.film_roll_shuttle'
    @rotation = []

    # set up pager
    unless @options.pager is false
      @pager = jQuery '<div class="film_roll_pager">'
      @div.append @pager
      @children.each (i,e) =>
        link = jQuery("<a href='#' data-id='#{e.id}'><span>#{i+1}</span></a>")
        @pager.append link
        link.click =>
          @index = i
          # here direction only determines which side will be checked
          # for sufficient visible items once the item is slid into view
          rotation_index = jQuery.inArray @children[i], @rotation
          direction = if rotation_index < (@children.length/2) then 'right' else 'left'
          @moveToIndex @index, direction, true
    @pager_links = @div.find('.film_roll_pager a')
    
    # find children / width / height
    @width = @height = 0
    @children.each (i,e) =>
      @rotation.push e
      $el = jQuery(e)
      $el.attr 'style', 'position:relative; display:inline-block; vertical-align:middle'
      _width = $el.width()
      @width += _width
      el_height = $el.outerHeight(true)
      if el_height > @height
        @height = el_height
      $el.addClass 'film_roll_child'

    # set width and height
    @shuttle.width @width * 2 # double it to take care of any styling
    if @options.height
      @height = parseInt(@options.height,10)
    @wrapper.height @height
    @shuttle.height @height

    # config left / right buttons
    if @options.prev && @options.next
      @prev = jQuery @options.prev
      @next = jQuery @options.next
    else
      @wrapper.append '<a class="film_roll_prev" href="#">&lsaquo;</a>'
      @wrapper.append '<a class="film_roll_next" href="#">&rsaquo;</a>'
      @prev = @div.find '.film_roll_prev'
      @next = @div.find '.film_roll_next'

    # add events for next prev
    @prev.click @moveRight
    @next.click @moveLeft

    # set index and move to position
    @index = @options.start_index || 0
    @moveToIndex @index, 'right', false

    # start timer
    @interval = @options.interval || 3000
    @animation = @options.animation || @interval/3
    unless @options.scroll is false
      @configureTimer()
      @div.hover @clearTimer, @configureTimer
      @prev.hover @clearTimer, @configureTimer
      @next.hover @clearTimer, @configureTimer

    # set window resize event
    jQuery(window).resize =>
      @resize()
    @

  configureTimer: =>
    @timer = setInterval =>
      @moveLeft()
    , @interval
    @

  clearTimer: =>
    clearInterval @timer

  marginLeft: (rotation_index) ->
    margin = 0
    for child, i in @rotation when i < rotation_index
      margin += jQuery(child).width()
    margin

  marginRight: (rotation_index) ->
    margin = 0
    for child, i in @rotation when i > rotation_index
      margin += jQuery(child).width()
    margin

  moveLeft: =>
    @index = (@index + 1) % @children.length
    @moveToIndex @index, 'left', true
    return false

  moveRight: =>
    @index -= 1
    if @index < 0
      @index = @children.length - 1
    @moveToIndex @index, 'right', true
    return false

  moveToIndex: (index, direction, animate) ->
    animate = true if animate is null
    @children.removeClass 'active'
    @pager_links.removeClass 'active'
    child = @children[index]
    jQuery(child).addClass 'active'
    jQuery(@pager_links[index]).addClass 'active'
    wrapper_width = @wrapper.width()
    if wrapper_width < @width # rotate if the children are wider than the container
      # first, where is this photo? 
      rotation_index = jQuery.inArray child, @rotation
      # what should show on either side of this child
      visible_margin = (wrapper_width - jQuery(child).width())/2
      if direction == 'right'
        # rotate so blank space won't show at the end
        while rotation_index == 0 or @marginLeft(rotation_index) < visible_margin
          @rotateRight()
          rotation_index = jQuery.inArray child, @rotation
      else # we are moving left
        # rotate so blank space won't show at the end
        while rotation_index == @children.length - 1 or @marginRight(rotation_index) < visible_margin
          @rotateLeft()
          rotation_index = jQuery.inArray child, @rotation
      new_left_margin = -1*(@marginLeft(rotation_index)-visible_margin)
      if animate
        @shuttle.animate { 'left': new_left_margin }, @animation, 'swing'
      else
        @shuttle.css 'left', new_left_margin

  resize: ->
    clearTimeout @resize_timer
    @resize_timer = setTimeout =>
      @moveToIndex @index, 'left'
    , 200
    @

  rotateLeft: =>
    _css_left = @shuttle.css('left')
    _shuttle_left = if _css_left then parseInt(_css_left, 10) else 0
    _first_child = @rotation.shift()
    @rotation.push _first_child
    @shuttle.append jQuery(_first_child).detach()
    @shuttle.css 'left', _shuttle_left + jQuery(_first_child).width()

  rotateRight: =>
    _css_left = @shuttle.css('left')
    _shuttle_left = if _css_left then parseInt(_css_left, 10) else 0
    _last_child = @rotation.pop()
    @rotation.unshift _last_child
    @shuttle.prepend jQuery(_last_child).detach()
    @shuttle.css 'left', _shuttle_left - jQuery(_last_child).width()

