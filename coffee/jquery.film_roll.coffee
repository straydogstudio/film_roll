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

  constructor: (@options = {}) ->
    if @options.container
      @div = jQuery @options.container
      if @div.length
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
        .film_roll_pager a {width:5px; height:5px; border:2px solid #333; border-radius:5px; display:inline-block; margin:0 5px 0 0; transition: all 1s ease}
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
    
    # set classes and get rotation
    first_child = null
    @children.each (i,e) =>
      $el = jQuery(e)
      $el.attr 'style', 'position:relative; display:inline-block; vertical-align:middle'
      $el.attr 'data-film-roll-child-id', i
      $el.addClass "film_roll_child"
      @rotation.push e

    # set height and temporary width
    shuttle_width = if @options.shuttle_width then parseInt(@options.shuttle_width,10) else 10000
    @shuttle.width shuttle_width # until the page loads
    @height = if @options.height then parseInt(@options.height,10) else 0
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

    # expand unless blocked
    if @options.expand is true
      @expand()

    # start timer
    @interval = @options.interval || 4000
    @animation = @options.animation || @interval/4
    unless @options.scroll is false
      @div.hover @clearScroll, @configureScroll
      if @options.prev && @options.next
        @prev.hover @clearScroll, @configureScroll
        @next.hover @clearScroll, @configureScroll

    # set window resize event
    jQuery(window).resize =>
      @resize()

    # lastly, set the window load event to resize after images are loaded
    jQuery(window).load =>
      @configureWidths()
      @moveToIndex @index, 'right', false
      unless @options.scroll is false
        @configureScroll()

    @

  configureWidths: =>
    # find children / width / height
    @width = max_el_height = 0
    @children.each (i,e) =>
      $el = jQuery(e)
      @width += $el.width()
      el_height = $el.outerHeight(true)
      if el_height > max_el_height
        max_el_height = el_height
    unless @options.height
      @height = max_el_height

    # set width and height
    @wrapper.height @height
    @shuttle.height @height
    @real_width = @width

    # expand if not quite wide enough
    wrapper_width = @wrapper.width()
    if wrapper_width < @real_width and wrapper_width * 2 > @real_width and not @options.expand?
      @expand()

    # set shuttle width
    @real_width *= 3 if @options.expand is true
    @shuttle.width @real_width * 2 # double it to take care of any styling and rotation  

    @

  configureScroll: =>
    @timer = setInterval =>
      @moveLeft()
    , @interval
    @

  clearScroll: =>
    clearInterval @timer
    @

  expand: =>
    @options.expand = true
    first_child = null
    @children.each (i,e) =>
      $el = jQuery(e)
      first_child ||= $el
      post = $el.clone()
      pre  = $el.clone()
      id   = $el.attr 'id'
      if id
        post.attr 'id', id+'_post'
        pre.attr  'id', id+'_pre'
      @shuttle.append post
      first_child.before pre

  marginLeft: (rotation_index, offset = 0) ->
    margin = 0
    for child, i in @rotation
      if i < rotation_index and i>= offset
        margin += jQuery(child).width()
    margin

  marginRight: (rotation_index, offset = 0) ->
    offset = @rotation.length - offset - 1
    margin = 0
    for child, i in @rotation
      if i > rotation_index and i <= offset
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

  moveToIndex: (index, direction, animate = true) ->
    child = @children[index]
    rotation_index = jQuery.inArray child, @rotation
    if @options.expand
      html_children = @shuttle.children()
      html_children.removeClass 'active'
      jQuery(html_children[rotation_index + @children.length]).addClass 'active'
    else
      @children.removeClass 'active'
      jQuery(child).addClass 'active'
    # adjust pager
    @pager_links.removeClass 'active'
    jQuery(@pager_links[index]).addClass 'active'
    # if shuttle width is wider than the wrapper, we need to rotate
    wrapper_width = @wrapper.width()
    if wrapper_width < @real_width # rotate if the children are wider than the container
      # first, where is this photo? 
      # what should show on either side of this child
      visible_margin = (wrapper_width - jQuery(child).width())/2
      if direction == 'right'
        # rotate so blank space won't show after animation
        while rotation_index == 0 or @marginLeft(rotation_index) < visible_margin
          @rotateRight()
          rotation_index = jQuery.inArray child, @rotation
      else # we are moving left
        # rotate so blank space won't show after animation
        while rotation_index == @children.length - 1 or @marginRight(rotation_index) < visible_margin
          @rotateLeft()
          rotation_index = jQuery.inArray child, @rotation
      new_left_margin = -1*(@marginLeft(rotation_index)-visible_margin)
      if @options.expand
        new_left_margin -= @width
      if animate
        @shuttle.animate { 'left': new_left_margin }, @animation, 'swing'
      else
        @shuttle.css 'left', new_left_margin
    else
      @shuttle.css 'left', (wrapper_width - @width)/2
    @

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
    @shuttle.css 'left', _shuttle_left + jQuery(_first_child).width()
    @shuttle.append @shuttle.children().first().detach()

  rotateRight: =>
    _css_left = @shuttle.css('left')
    _shuttle_left = if _css_left then parseInt(_css_left, 10) else 0
    _last_child = @rotation.pop()
    @rotation.unshift _last_child
    @shuttle.css 'left', _shuttle_left - jQuery(_last_child).width()
    @shuttle.prepend @shuttle.children().last().detach()


