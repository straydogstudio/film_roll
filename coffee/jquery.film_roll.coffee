###
  FilmRoll (for jQuery)
  version: 0.1.8 (2/25/14)
  @requires jQuery >= v1.4

  By Noel Peden
  Examples at http://straydogstudio.github.io/film_roll

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
    # create divs for absolute positioning
    @children = @div.children()
    @children.wrapAll '<div class="film_roll_wrapper"></div>'
    @children.wrapAll '<div class="film_roll_shuttle"></div>'
    @wrapper = @div.find '.film_roll_wrapper'
    @shuttle = @div.find '.film_roll_shuttle'
    @rotation = []
    @ldupes = []
    @rdupes = []

    # set height and temporary width
    @shuttle.width if @options.shuttle_width then parseInt(@options.shuttle_width,10) else 10000
    if @options.start_height
      @wrapper.height parseInt(@options.start_height, 10)

    # add styling
    if @options.vertical_center
      @shuttle.addClass 'vertical_center'
    unless @options.no_css == true or document.film_roll_styles_added
      jQuery("<style type='text/css'>
.film_roll_wrapper{display:block;text-align:center;float:none;position:relative;top:auto;right:auto;bottom:auto;left:auto;z-index:auto;width:100%;height:100%;margin:0 !important;padding:0 !important;overflow:hidden;}
.film_roll_shuttle{text-align:left;float:none;position:relative;top:0;left:0;right:auto;bottom:auto;height:100%;margin:0 !important;padding:0 !important;z-index:auto;}
.film_roll_shuttle.vertical_center:before{content:'';display:inline-block;height:100%;vertical-align:middle;margin-right:-0.25em;}
.film_roll_child{position:relative;display:inline-block;*display:inline;vertical-align:middle;zoom:1;}
.film_roll_prev,.film_roll_next{position:absolute;top:48%;left:15px;width:40px;height:40px;margin:-20px 0 0 0;padding:0;font-size:60px;font-weight:100;line-height:30px;color:white;text-align:center;background:#222;border:3px solid white;border-radius:23px;opacity:0.5}
.film_roll_prev:hover,.film_roll_next:hover{color:white;text-decoration:none;opacity:0.9}
.film_roll_next{left:auto;right:15px}
.film_roll_pager{text-align:center;}
.film_roll_pager a{width:5px;height:5px;border:2px solid #333;border-radius:5px;display:inline-block;margin:0 5px 0 0;transition:all 1s ease}
.film_roll_pager a:hover{background:#666}
.film_roll_pager a.active{background:#333}
.film_roll_pager span{display:none}
.film_roll_pager a,a.film_roll_prev,a.film_roll_next{-webkit-box-sizing: content-box;-moz-box-sizing: content-box;box-sizing: content-box;}
</style>").appendTo('head')
      document.film_roll_styles_added = true

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
          @moveToIndex @index, 'best', true
          return false
    @pager_links = @div.find('.film_roll_pager a')

    # hover events
    if @options.hover == 'scroll'
      @options.scroll = false
      @hover_in  = =>
        clearTimeout @hover_timer
        @hover_timer = setTimeout =>
          @moveLeft()
          @configureScroll()
        , 300
      @hover_out = @clearScroll
    else
      unless @options.hover == false
        @hover_in  = =>
          clearTimeout @hover_timer
          @hover_timer = setTimeout =>
            @clearScroll()
          , 300
        @hover_out = @configureScroll

    # detect first mouse movement div
    # some browsers do not set hover if the page loads while the mouse is over the scroll
    unless @options.hover is false
      @mouse_catcher = jQuery('<div style="position:absolute; top:0; left: 0; height: 100%; width: 100%;" class="film_roll_mouse_catcher"></div>')
      @mouse_catcher.appendTo(@wrapper).mousemove () =>
        @hover_in()
        @mouse_catcher.remove()

    # set classes and get rotation
    first_child = null
    @children.each (i,e) =>
      $el = jQuery(e)
      $el.attr 'data-film-roll-child-id', i
      $el.addClass "film_roll_child"
      @rotation.push e

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
    @prev.click =>
      @moveRight()
    @next.click =>
      @moveLeft()

    # set start index
    @index = @options.start_index || 0

    # scroll variables
    @interval = @options.interval || 4000
    @animation = @options.animation || @interval/4
    @easing = if @options.easing == false then false else (@options.easing || 'swing')

    if @options.easing == 'css'
      jQuery("<style type='text/css'>#{@options.container} .film_roll_shuttle.transition {transition: left #{@animation}ms;}</style>").appendTo('head')
      @shuttle.on "transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
        console.log 'transitioned'
        @shuttle.removeClass 'transition'
        @div.trigger jQuery.Event("film_roll:moved")
        @moveToClear(@direction)

    # configure window resize event
    unless @options.resize is false
      jQuery(window).resize =>
        @resize()

    # on load configure widths, scroll, hover, and start
    if @options.configure_load
      if typeof(@options.configure_load) == 'function'
        @options.configure_load.apply this, arguments
      else
        @configureLoad()
    else
      jQuery(window).load @configureLoad

    @div.trigger jQuery.Event("film_roll:dom_ready")

    this

  bestDirection: (child, rotation_index) ->
    rotation_index ?= jQuery.inArray child, @rotation
    if rotation_index < (@children.length/2) then 'right' else 'left'

  configureHover: =>
    @div.hover @hover_in, @hover_out
    if @options.prev && @options.next
      @prev.hover @hover_in, @hover_out
      @next.hover @hover_in, @hover_out

  configureLoad: =>
    @configureWidths()
    @moveToIndex @index, 'right', true
    if @options.hover == 'scroll'
      @options.scroll = false
      @configureHover()
    else if @options.scroll != false
      @configureScroll()
      unless @options.hover is false
        @configureHover()

  configureWidths: =>
    # find children / width / height
    @width = min_height = 0
    # reset for resizing
    @wrapper.css {
      height: '',
      'min-height': 0
    }
    @shuttle.width('').removeClass('film_roll_shuttle').addClass 'film_roll_resizing'
    @children.width ''
    @div.trigger jQuery.Event("film_roll:resizing")
    @child_widths = []
    @children.each (i,e) =>
      $el = jQuery(e)
      el_width = $el.outerWidth(true)
      $el.width el_width
      @child_widths.push el_width
      @width += el_width
      unless @options.height
        el_height = $el.outerHeight(true)
        if el_height > min_height
          min_height = el_height
      e
    if @options.height
      @wrapper.height @options.height
    else
      @wrapper.height ''
      @wrapper.css 'min-height', min_height

    # set width
    @real_width = @width
    # double the width to take care of any styling and rotation
    @shuttle.width(@real_width * 2).removeClass('film_roll_resizing').addClass 'film_roll_shuttle'

    this

  configureScroll: =>
    unless @scrolled is true
      @timer = setInterval =>
        @moveLeft()
      , @interval
      @scrolled = true
    this

  clearScroll: =>
    unless @scrolled is false
      clearInterval @timer
      @scrolled = false
    this

  childIndex: (child) ->
    child = jQuery(child)[0]
    if child
      child_id = child.getAttribute 'data-film-roll-child-id'
      child_id || jQuery.inArray child, @children

  childWidth: (child) ->
    index = @childIndex child
    @child_widths[index] || jQuery(child).outerWidth(true)

  rotationIndex: (child) ->
    jQuery.inArray child, @rotation

  marginLeft: (rotation_index, offset = 0) ->
    margin = 0
    # for child, i in @rotation
      # if i < rotation_index and i>= offset
        # margin += @childWidth(child)
    limit = rotation_index
    while offset < limit
      margin += @childWidth(@rotation[offset++])
    child_id = @rotation[rotation_index].getAttribute('data-film-roll-child-id')
    jQuery.each @rdupes, (i, dup) =>
      if dup.data('filmRollChildId') != child_id
        margin += @childWidth(dup)
    margin

  marginRight: (rotation_index, offset = 0) ->
    offset = @rotation.length - offset - 1
    margin = 0
    # for child, i in @rotation
    #   if i > rotation_index and i <= offset
    #     margin += @childWidth(child)
    i = rotation_index + 1
    while i < offset
      margin += @childWidth(@rotation[i++])
    child_id = @rotation[rotation_index].getAttribute('data-film-roll-child-id')
    jQuery.each @ldupes, (i, dup) =>
      if dup.data('filmRollChildId') != child_id
        margin += @childWidth(dup)
    margin

  moveLeft: =>
    @index = (@index + 1) % @children.length
    @moveToIndex @index, 'left', true
    return false

  moveRight: =>
    l = @children.length
    @index = (@index+l-1) % l
    @moveToIndex @index, 'right', true
    return false

  moveToChild: (element) ->
    child_index = @childIndex element
    if child_index > -1
      @moveToIndex child_index

  moveToIndex: (index, direction) ->
    @index = index
    scrolled = @scrolled
    @clearScroll()
    child = @children[index]
    rotation_index = jQuery.inArray child, @rotation
    if !direction or direction == 'best'
      direction = @bestDirection(child, rotation_index)
    @children.removeClass 'active'
    jQuery(child).addClass('active').trigger jQuery.Event("film_roll:activate")
    # adjust pager
    @pager_links.removeClass 'active'
    jQuery(@pager_links[index]).addClass 'active'
    # if shuttle width is wider than the wrapper, we need to rotate
    wrapper_width = @wrapper.width()
    if wrapper_width < @real_width # rotate if the children are wider than the container
      # first, where is this photo?
      # what should show on either side of this child
      visible_margin = (wrapper_width - @child_widths[index])/2
      shuttle_left = @shuttleLeft()
      if direction == 'right'
        # clone so blank space won't show after animation
        margin_left = @marginLeft(rotation_index)
        while margin_left < visible_margin
          margin_left += @cloneRight(shuttle_left)
          @rotation.unshift @rotation.pop()
      else # we are moving left
        # rotate so blank space won't show after animation
        margin_right = @marginRight(rotation_index)
        while margin_right < visible_margin
          margin_right += @cloneLeft()
          @rotation.push @rotation.shift()
        margin_left = @marginLeft(rotation_index)
      @shuttle_left = new_left_margin = -1*(margin_left-visible_margin)
      if @easing == 'css'
        @shuttle.addClass 'transition'
        @direction = direction
        @shuttle.css 'left', new_left_margin
      else if @easing == false
        @shuttle.css 'left', new_left_margin
        @div.trigger jQuery.Event("film_roll:moved")
        @moveToClear(direction)
      else
        direction_class = "moving_#{direction}"
        @shuttle.addClass direction_class
        @div.trigger jQuery.Event("film_roll:moving")
        @shuttle.stop().animate { 'left': new_left_margin }, @animation, @easing, =>
          @shuttle.removeClass direction_class
          @moveToClear(direction)
          @div.trigger jQuery.Event("film_roll:moved")
    else
      @shuttle.css 'left', (wrapper_width - @width)/2
    if scrolled
      @configureScroll()
    this

  moveToClear: (direction) ->
    shuttle_left = @shuttle_left
    while dup = @ldupes.shift()
      i = @childIndex dup
      @shuttle.append jQuery(@children[i]).detach()
      shuttle_left += @child_widths[i]
      dup.remove()
    while dup = @rdupes.shift()
      i = @childIndex dup
      @shuttle.prepend jQuery(@children[i]).detach()
      dup.remove()
    @shuttle.css 'left', shuttle_left
    # @shuttle.css 'left', (wrapper_width - @width)/2
    delete @shuttle_left
    shuttle_left

  resize: =>
    clearTimeout @resize_timer
    @resize_timer = setTimeout =>
      scrolled = @scrolled
      @clearScroll()
      if scrolled
        @configureScroll()
      @configureWidths()
      @moveToIndex @index, 'best'
      @div.trigger jQuery.Event("film_roll:resized")
    , 200
    this

  # clearLeft: ->
  #   for dup in @ldupes
  #     dup.remove()
  #   @ldupes = []
  #   this

  cloneLeft: (i = 1) =>
    j = -1
    clone_width  = 0
    offset = @ldupes.length
    length = @rotation.length
    while (j += 1) < i
      k = (j+offset) % length
      dup = jQuery(@rotation[k]).clone()
      clone_width += @childWidth(dup)
      @shuttle.append dup
      @ldupes.push dup
    clone_width

  # rotateLeft: (i = 1) =>
  #   width_change = 0
  #   j = -1
  #   while (j += 1) < i
  #     first_child = @shuttle.children().first()
  #     @shuttle.append first_child.detach()
  #     width_change += @childWidth(first_child)
  #   width_change

  # clearRight: ->
  #   for dup in @rdupes
  #     dup.remove()
  #   @rdupes = []
  #   this

  cloneRight: (shuttle_left, i = 1) =>
    clone_width  = 0
    offset = @rdupes.length
    length = @rotation.length
    j = -1
    while (j += 1) < i
      k = (j+length-1-offset) % length
      dup = jQuery(@rotation[k]).clone()
      clone_width += @childWidth(dup)
      @shuttle.prepend dup
      @rdupes.push dup
    @shuttle.css 'left', shuttle_left - clone_width
    clone_width

  # rotateRight: (i = 1) =>
  #   j = -1
  #   while (j += 1) < i
  #     _last_child = @rotation.pop()
  #     @rotation.unshift _last_child
  #     last_child  = jQuery(_last_child)
  #     @shuttle.prepend last_child.detach()
  #   # @clearRight()
  #   this

  shuttleLeft: ->
    css_left = @shuttle.css('left')
    if css_left then parseInt(css_left, 10) else 0

  # adapted from https://gist.github.com/jackfuchs/556448
  # @supportsCSS: (p) ->
  #   b = document.body || document.documentElement
  #   s = b.style
  #   # No css support detected
  #   if typeof s == 'undefined'
  #     return false
  #   # Tests for standard prop
  #   if typeof s[p] == 'string'
  #     return true
  #   # Tests for vendor specific prop
  #   v = ['Moz', 'Webkit', 'Khtml', 'O', 'ms', 'Icab']
  #   p = p.charAt(0).toUpperCase() + p.substr(1)
  #   for num in [0..v.length-1]
  #     if typeof s[v[i] + p] == 'string'
  #       return true


