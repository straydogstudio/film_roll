###
  FilmRoll (for jQuery)
  version: 0.1.16 (4/13/15)
  @requires $ >= v1.4

  By Noel Peden
  Examples at http://straydogstudio.github.io/film_roll

  Licensed under the MIT:
    http://www.opensource.org/licenses/mit-license.php

  Usage:
    var film_roll = new FilmRoll({container: '#container_id', OPTIONS});
###
( ($) ->

  class @FilmRoll

    constructor: (@options = {}) ->
      if @options.container
        @div = $ @options.container
        if @div.length
          inst = @div.data 'film_roll_instance'
          if inst
            return inst
          inst = @configure()
          @div.data 'film_roll_instance', inst
          return inst

    configure: ->
      # create divs for absolute positioning
      @children = @div.children()
      @children.wrapAll '<div class="film_roll_wrapper"></div>'
      @children.wrapAll '<div class="film_roll_shuttle"></div>'
      @wrapper = @div.find '.film_roll_wrapper'
      @shuttle = @div.find '.film_roll_shuttle'
      @rotation = []

      # set height and temporary width
      @shuttle.width if @options.shuttle_width then parseInt(@options.shuttle_width, 10) else 10000
      if @options.start_height
        @wrapper.height parseInt(@options.start_height, 10)

      # add styling
      if @options.vertical_center
        @shuttle.addClass 'vertical_center'
      unless @options.no_css == true or document.film_roll_styles_added
        $("<style type='text/css'>
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
        @pager = $ '<div class="film_roll_pager">'
        @div.append @pager
        @children.each (i, e) =>
          link = $("<a href='#' data-id='#{e.id}'><span>#{i+1}</span></a>")
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
        @mouse_catcher = $('<div style="position:absolute; top:0; left: 0; height: 100%; width: 100%;" class="film_roll_mouse_catcher"></div>')
        @mouse_catcher.appendTo(@wrapper).mousemove () =>
          @hover_in()
          @mouse_catcher.remove()

      # set classes and get rotation
      first_child = null
      @children.each (i, e) =>
        $el = $(e)
        $el.attr 'data-film-roll-child-id', i
        $el.addClass "film_roll_child"
        @rotation.push e

      # config left / right buttons
      unless @options.prev is false
        if @options.prev && @options.next
          @prev = $ @options.prev
        else
          @wrapper.append '<a class="film_roll_prev" href="#">&lsaquo;</a>'
          @prev = @div.find '.film_roll_prev'
        # add events for next prev
        @prev.click =>
          @moveRight()
      unless @options.next is false
        if @options.next
          @next = $ @options.next
        else
          @wrapper.append '<a class="film_roll_next" href="#">&rsaquo;</a>'
          @next = @div.find '.film_roll_next'
        # add events for next prev
        @next.click =>
          @moveLeft()

      # set start index
      @index = @options.start_index || 0

      # set pixel offset
      @offset = @options.offset || 0

      # scroll variables
      @interval = @options.interval || 4000
      @animation = @options.animation || @interval/4
      @easing = @options.easing || FilmRoll.default_easing

      # configure window resize event
      unless @options.resize is false
        $(window).resize =>
          @resize()

      # on load configure widths, scroll, hover, and start
      if @options.configure_load
        if typeof(@options.configure_load) == 'function'
          @options.configure_load.apply this, arguments
        else if typeof(@options.configure_load) == 'number'
          setTimeout =>
            @configureLoad()
          , @options.configure_load
        else
          @configureLoad()
      else
        $(window).load @configureLoad

      unless @options.swipe is false
        @configureSwipe()

      @div.trigger $.Event("film_roll:dom_ready")

      this

    bestDirection: (child, rotation_index) ->
      rotation_index ||= $.inArray child, @rotation
      if rotation_index < (@children.length/2) then 'right' else 'left'

    cancelClick: (event) ->
      if $(this).hasClass 'fr-no-click'
        # $this.closest('.film_roll_wrapper').find('a.fr-no-click').removeClass('fr-no-click')
        event.preventDefault()
        return false
      return true

    childIndex: (child) ->
      $.inArray child, @children

    childWidth: (child) ->
      index = @childIndex child
      @child_widths[index] || $(child).outerWidth(true)

    clearScroll: =>
      unless @scrolled is false
        clearInterval @timer
        @scrolled = false
      this

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

    configureScroll: =>
      unless @scrolled is true
        @timer = setInterval =>
          @moveLeft()
        , @interval
        @scrolled = true
      this

    configureSwipe: =>
      unless typeof $.fn.swipe == 'undefined'
        @div.swipe {
          swipeStatus: (event, phase, direction, distance) =>
            if direction == 'up' or direction == 'down'
              return false
            if phase == 'start'
              wrapper_width = @wrapper.width()
              if wrapper_width >= @real_width || @children.length == 1
                return false
              @was_scrolled = @scrolled
              if @scrolled
                @clearScroll()
              @active_half = @child_widths[@index]/2
              rotation_index = $.inArray @children[@index], @rotation
              @offscreen_left = parseInt(@shuttle.css('left'), 10)
              @offscreen_right = @marginRight(rotation_index) - (wrapper_width - @child_widths[@index])/2
              @div.find('a').addClass 'fr-no-click'
            else if phase == 'move'
              if direction == 'left'
                # do we need to advance
                if distance > @active_half
                  $(@children[@index]).removeClass('active')
                  @index = (@index + 1) % @children.length
                  $(@children[@index]).addClass('active')
                  @active_half += @child_widths[@index]
                # do we need to rotate
                if distance > @offscreen_right
                  @offscreen_left = @rotateLeft() + distance
                  @offscreen_right += @childWidth(@rotation[@rotation.length-1])
                @shuttle.css 'left', @offscreen_left - distance
              else
                # do we need to advance
                if distance > @active_half
                  $(@children[@index]).removeClass('active')
                  @index -= 1
                  if @index < 0
                    @index = @children.length - 1
                  $(@children[@index]).addClass('active')
                  @active_half += @child_widths[@index]
                # do we need to rotate
                if distance + @offscreen_left > 0
                  @offscreen_left = @rotateRight() - distance
                @shuttle.css 'left', @offscreen_left + distance
            else
              if phase == 'end'
                @moveToIndex(@index, direction)
              else if phase == 'cancel'
                @moveToIndex(@index, (if direction == 'right' then 'left' else 'right'))
                @div.find('a.fr-no-click').removeClass 'fr-no-click'
              if @was_scrolled
                @configureScroll()
            true
          ,
          excludedElements:'label, button, input, select, textarea, .noSwipe',
          allowPageScroll: 'vertical'
        }
        @div.find('a').on 'click', @cancelClick

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
      @div.trigger $.Event("film_roll:resizing")
      @child_widths = []
      if @options.height and @options.height.toString().match(/^\+/)
        @options.height_padding = parseInt(@options.height, 10)
        @options.height = null
      else
        @options.height_padding = 0
      @children.each (i, e) =>
        $el = $(e)
        $el.width $el.outerWidth(true)
        #Sometimes $.width changes the value, so we get it again
        el_width = $el.outerWidth(true)
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
        @wrapper.css 'min-height', min_height + @options.height_padding

      # set width
      @real_width = @width
      # double the width to take care of any styling and rotation
      @shuttle.width(@real_width * 2).removeClass('film_roll_resizing').addClass 'film_roll_shuttle'

      # hide prev/next if less than visible width
      if @wrapper.width() > @real_width
        unless @options.force_buttons || @options.prev is false
          @prev.hide()
        unless @options.force_buttons || @options.next is false
          @next.hide()
      else
        unless @options.prev is false
          @prev.show()
        unless @options.next is false
          @next.show()

      this

    rotationIndex: (child) ->
      $.inArray child, @rotation

    marginLeft: (rotation_index) ->
      margin = 0
      for child, i in @rotation
        if i < rotation_index and i>= 0
          margin += @childWidth(child)
      margin

    marginRight: (rotation_index) ->
      offset = @rotation.length - 1
      margin = 0
      for child, i in @rotation
        if i > rotation_index and i <= offset
          margin += @childWidth(child)
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

    moveToChild: (element) ->
      child_index = @childIndex $(element)[0]
      if child_index > -1
        @moveToIndex child_index

    moveToIndex: (index, direction, animate = true) ->
      @index = index
      scrolled = @scrolled
      @clearScroll()
      child = @children[index]
      rotation_index = $.inArray child, @rotation
      if !direction or direction == 'best'
        direction = @bestDirection(child, rotation_index)
      @children.removeClass 'active'
      $(child).addClass('active').trigger $.Event("film_roll:activate")
      # adjust pager
      @pager_links.removeClass 'active'
      $(@pager_links[index]).addClass 'active'
      # if shuttle width is wider than the wrapper, we need to rotate
      wrapper_width = @wrapper.width()
      # what should show on either side of this child
      remainder = (wrapper_width - @child_widths[index])
      if @options.position == 'left'
        visible_margin_left = 0 + @offset
      else if @options.position == 'right'
        visible_margin_left = wrapper_width - @child_widths[index] + @offset
      else # center
        visible_margin_left = remainder/2 + @offset
      visible_margin_right = remainder - visible_margin_left
      if wrapper_width < @real_width && @children.length > 1 || @options.force_rotate # rotate if the children are wider than the container
        if direction == 'right'
          # rotate so blank space won't show after animation
          while rotation_index == 0 or @marginLeft(rotation_index) < visible_margin_left
            @rotateRight()
            rotation_index = $.inArray child, @rotation
        else # we are moving left
          # rotate so blank space won't show after animation
          while rotation_index == @children.length - 1 or @marginRight(rotation_index) < visible_margin_right
            @rotateLeft()
            rotation_index = $.inArray child, @rotation
      new_left_margin = -1*(@marginLeft(rotation_index)-visible_margin_left)
      if animate
        direction_class = "moving_#{direction}"
        @shuttle.addClass direction_class
        @div.trigger $.Event("film_roll:moving")
        @shuttle.stop().animate { 'left': new_left_margin }, @animation, @easing, =>
          @shuttle.removeClass direction_class
          @div.trigger $.Event("film_roll:moved")
      else
        @shuttle.css 'left', new_left_margin
        @div.trigger $.Event("film_roll:moved")
      # else
        # @shuttle.css 'left', (wrapper_width - @width)/2
      if scrolled
        @configureScroll()
      this

    resize: =>
      clearTimeout @resize_timer
      @resize_timer = setTimeout =>
        scrolled = @scrolled
        @clearScroll()
        if scrolled
          @configureScroll()
        @configureWidths()
        @moveToIndex @index, 'best'
        @div.trigger $.Event("film_roll:resized")
      , 200
      this

    rotateLeft: =>
      _css_left = @shuttle.css('left')
      _shuttle_left = if _css_left then parseInt(_css_left, 10) else 0
      _first_child = @rotation.shift()
      _new_left = _shuttle_left + @childWidth(_first_child)
      @rotation.push _first_child
      @shuttle.css 'left', _new_left
      @shuttle.append @shuttle.children().first().detach()
      _new_left

    rotateRight: =>
      _css_left = @shuttle.css('left')
      _shuttle_left = if _css_left then parseInt(_css_left, 10) else 0
      _last_child = @rotation.pop()
      _new_left = _shuttle_left - @childWidth(_last_child)
      @rotation.unshift _last_child
      @shuttle.css 'left', _new_left
      @shuttle.prepend @shuttle.children().last().detach()
      _new_left

  @FilmRoll.default_easing = 'swing'

) jQuery
