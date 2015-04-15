#FilmRoll
**A lightweight jQuery carousel**


##Description

**FilmRoll** is a lightweight jQuery carousel (12 kb minified) that focuses on one item at a time, centering it in the view, regardless of the relative sizes of the carousel items.

[**SEE DEMO**](http://straydogstudio.github.io/film_roll)

---

##UPDATE

* Two new features have been added:
  - FilmRoll now supports positioning. You can specify a position of 'left', 'right', or 'center' (the default.) The active child element will be moved to the left, right, or center of the visible window. There is also an offset option which will bump the position left (negative) or right (positive) by the specified number of pixels if you need it. (4/13/2015)
  - If the child elements are smaller than the visible window, they are now shuttled back and forth, but they are _NOT ROTATED_ unless the force_rotate option is specified (see the third carousel on the [demo page](http://straydogstudio.github.io/film_roll).) In addition, the previous / next buttons are hidden, unless the force_buttons option is specified. (4/13/2015)
  - Thanks to [prashantsani](https://github.com/prashantsani) for asking for, clarifying, and testing these features.
* The recent TouchSwipe support disabled all links inside the carousel. This has now been fixed in [0.1.15](https://github.com/straydogstudio/film_roll/releases). Thanks to [EmrahAkdeniz](https://github.com/EmrahAkdeniz) for reporting it. (3/15/2015)

##Features

- Centers one item at a time in the view
- Uses css classes for easy styling / transitions
- Provides previous / next buttons and pagination automatically
- Defaults to auto scroll with pause on hover
- Supports [full screen usage](http://straydogstudio.github.io/film_roll/fullscreen.html)
- Swipe movement if [TouchSwipe](https://github.com/mattbryson/TouchSwipe-Jquery-Plugin) is present
- Yet to be implemented:
    - Simple external link using classes/ids (For now [see Javascript below](#using-javascript))

##A Note on Performance and [GSAP](http://www.greensock.com/gsap-js/)

jQuery's animation tends to cause high cpu load. The best solution for this is to use [GreenSock](http://www.greensock.com/gsap-js/) to replace the jQuery animate function. 

To do so, include the following minimal markup, unless you are using the complete library:

```html
<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/plugins/CSSPlugin.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/easing/EasePack.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenLite.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/gsap/latest/jquery.gsap.min.js"></script>
```

##Usage

###Installation

Download [jquery.film_roll.min.js](https://github.com/straydogstudio/film_roll/releases) and place it in your scripts directory.

For swipe movement, include [TouchSwipe](https://github.com/mattbryson/TouchSwipe-Jquery-Plugin).

Then link it in your web page. E.g:

```html
<script src="js/jquery.film_roll.min.js"></script>
<script src="js/jquery.touchSwipe.min.js"></script>
```

If you use [Bower](http://bower.io/) install with `FilmRoll`:

```
bower install FilmRoll
```

[TouchSwipe](https://github.com/mattbryson/TouchSwipe-Jquery-Plugin) will be included as a dependency:

```html
<script src="/bower_components/FilmRoll/js/jquery.film_roll.min.js"></script>
<script src="/bower_components/jquery-touchswipe/jquery.touchSwipe.min.js"></script>
```

###Markup

FilmRoll expects a parent div with children div elements, though it should work with most any child element:

```html
	<div id="film_roll">
	  <div>
	    <a href="..."><img src="..."> </a>
	  </div>
	  <div>
	    <a href="..."><img src="..."> </a>
	  </div>
	</div>
```

Using non `<div>` tags as children works fine. The tag used may require (significant) styling to get it to work like a div.

###Create

Create the FilmRoll instance on dom:ready:

```javascript
  jQuery(function() {
    var film_roll = new FilmRoll({
        container: '#container_id',
      });
  });
```

If you need to create FilmRoll on page load, use the `configure_load` option:

```javascript
  jQuery(window).load(function() {
    var film_roll = new FilmRoll({
        configure_load: true,
        container: '#container_id',
      });
  });
```

###Configuration
**var film_roll = new FilmRoll({container: '#container_id', OPTIONS})**

Params:

- **:container** (Mandatory): The div that contains all elements that are to be displayed.

Typical Options:
- **:height**: Set the height of the film_roll wrapper (which sits inside the container.) Options are:
    - **Not set** (default): The wrapper will be the height of the container (100%), with a min-height of the tallest element.
    - **Integer/string**: Set the height directly. Can be an integer (pixels) or a string ('75%'.)
    - **'+Integer'**: Set the min-height to the highest child plus this integer value.
- **:interval**: The automatic scroll interval. 4 seconds by default. To turn off the automatic scroll, see the **scroll** option.
- **:next**: The jquery selector for the next button. Creates its own button by default. Use false for nothing. (See **prev** option.)
- **:pager**: Display pagination dots at the bottom of the carousel. True by default.
- **:position**: The position of the selected item within the container. Either 'left', 'right', or 'center'. Defaults to 'center'. See the **offset** option for further adjustment.
- **:prev**: The jquery selector for the previous button. Creates its own button by default. Use false for nothing. (See **next** option.)
- **:scroll**: Automatically scroll the carousel. True by default.

Other Options:

- **:animation**: The slide animation duration. 1/4 of interval by default. (See **interval** option.)
- **:configure_load**: Change how widths and hover response is configured. Options are:
    - **false** (default) Configure widths/hover on the window load event. FilmRoll assumes it has been instantiated on DOM ready ([jQuery.ready()](http://api.jquery.com/ready/).)
    - **true**: Configure widths/hover immediately (use if instantiating FilmRoll with the page load event)
    - **function**: Call the function instead of `configureLoad` (use to adjust content before calling `configureLoad` manually)
    - **integer**: Delay the call to `configureLoad` by the provided number of milliseconds (content may or may not be ready!)
- **:easing**: `swing` by default. jQuery also provides `linear`. [jQueryUI](http://api.jqueryui.com/easings/) provides more.
- **:force_buttons**: Show previous and next buttons even if the carousel is smaller than the container. Defaults to false.
- **:force_rotate**: Rotate child elements even if the carousel is smaller than the container. Defaults to false.
- **:hover**: If true, pause scroll on hover. If false, ignore hover. If 'scroll', scroll the carousel on hover. True by default.
- **:no_css**: Do not add [default css](#default-css) to page. You will want to include it otherwise.
- **:offset**: Offset the selected item position by given pixels. Positive to move right, negative to move left.
- **:resize**: Re-center the carousel on window resize. True by default. Set to false to perform your own logic before calling `film_roll_variable.resize();`.
- **:shuttle_width**: The starting shuttle width until the page loads. Defaults to 10000. See [troubleshooting](#double-rows-on-start-shuttle-width).
- **:start_height**: A starting height to give the carousel. Use only if you are having content flashes.
- **:start_index**: The index of the first element to center
- **:vertical_center**: Center children vertically in the container. Requires a browser with **:before** CSS pseudo class support. This is useful for a full screen carousel.

##Examples

### View the Project Page

View the [project page for working examples](http://straydogstudio.github.io/film_roll).

###Click to Center

If you want to center an item when someone clicks on it, try this:

```javascript
var film_roll = new FilmRoll({ container: '#container_id', ... });
$('#container_id div.film_roll_child').on('click',function() {
  film_roll.moveToChild(this);
});
```

### External Javascript Links

If you wish to move to a specific child using external javascript, use the `moveToIndex` or `moveToChild` functions:

```javascript
var film_roll = new FilmRoll(...);

$('#some_link_selector').click(function() {
  film_roll.moveToIndex(3);
  //or
  //film_roll.moveToChild($('#some_child_selector'));
  return false;
})
```

Note that `moveToIndex` uses a **zero based index**. E.g. if you have four items, the last item is 3.

### Full Screen usage

To use FilmRoll full screen, do the following:

- Using CSS, configure your container div to be 100% height (and width if necessary):

```css
#film_roll { height: 100%; }
```

- Do not pass a height when you instantiate the FilmRoll.
- To align the children to vertical center, use the vertical_center option:

```javascript
var film_roll = new FilmRoll({
    container: '#film_roll',
    vertical_center: true,
});
```

- If you leave the pager enabled, you'll want to bump it back up with CSS:

```css
.film_roll_pager {
    position: relative;
    top: -20px;
}
```

See an [example here](http://straydogstudio.github.io/film_roll/fullscreen.html).

###Styling

FilmRoll takes the following markup:

```html
  <div id="id_or_class_for_selection">
    <div>...</div>
    <div>...</div>
  </div>
```

and wraps all children with two divs, adds the class `film_roll_child` and a style element to the children, and adds the 'active' class to the centered child:

```html
  <div id="id_or_class_for_selection">
    <div class="film_roll_wrapper">
      <div class="film_roll_shuttle">
        <div class="film_roll_child active">…</div>
        <div class="film_roll_child">…</div>
      </div>
    </div>
  </div>
```

Use these classes to apply styling and effects. See the [example page](http://straydogstudio.github.io/film_roll).

##Theory

###On load vs. dom:loaded

FilmRoll is written to be called on dom:ready. It inserts all markup before display and configures itself to resize itself once the content is loaded (after the window.load event) because **it must have content to center an item on the page**.

If, for some reason, you need to call FilmRoll on window.load, or create it using an in page script, pass in the `configure_load: true` option to immediately call the relevant code:

```javascript
var film_roll = new FilmRoll({
    configure_load: true,
    container: '#container_id',
  });
```

### Responsive Images

FilmRoll must have a specific width for all child elements to center a given item. The question is, if the children have responsive sizes, what size should they be? To answer this question FilmRoll makes an assumption: the size of the child elements before all FilmRoll styling is applied is what they should be in the carousel. It will measure the child element widths, and fix them with inline styling.

You can take advantage of this in a few ways:

* If you have varying widths, and the heights end up changing in a mobile format, use CSS to force the height of all children. 
* Use one 'banner' child to resize all other children to the same height by calling javascript on the `film_roll:resizing` callback. See [callback examples below](#callbacks).

## Callbacks

FilmRoll provides the following callbacks. Unless otherwise noted, all events are triggered on the surrounding container that FilmRoll is initialized with:

- **film_roll:dom_ready**: When html content has been inserted but the page has not been loaded.
- **film_roll:moving**: When shuttle animation begins.
- **film_roll:moved**: When shuttle animation has finished.
- **film_roll:resizing**: Before FilmRoll measures the size of all content. The shuttle div is given the class `film_roll_resizing` during measurement. Called when the page has been loaded *and* when the page resizes. 
- **film_roll:resized**: When the FilmRoll has been resized.
- **film_roll:activate**: When a child element is activated. Triggered on the child.

**Note**: The callback name _includes_ the `film_roll:` prefix. E.g. use `film_roll:dom_ready`, _NOT_ `dom_ready`.

### Callback Examples

These callbacks are there to let you do most anything. Here are a few examples:

#### Display a Counter

With the following code, a counter is updated to display the slide per children when each move is finished:

```html
<div id="some_counter_div"></div>
```

```javascript
var film_roll = new FilmRoll({container: '#container_id',...});
$('#container_id').on('film_roll:moved', function(event) {
    $('#some_counter_div').html( (film_roll.index+1)+' / '+film_roll.children.length );
});
```

#### Remove CSS early

On the [demo page](http://straydogstudio.github.io/film_roll/) the second carousel uses CSS3 transformations to lean the pictures to the left or right when the class `moving_left` or `moving_right` is added so they look like they are flexing. But it looks really unnatural at the end without some help. To make it look more realistic, I use the `film_roll:moving` callback to set a timer that removes the class at 550ms instead of 1000ms:

```javascript
    $('#film_roll_2').on('film_roll:moving', function() {
      setTimeout(function() {
        $('#film_roll_2 div.film_roll_shuttle').removeClass('moving_left moving_right');
      }, 550);
    }); 
```

#### Responsive images

You can use `film_roll:resizing` to cause the carousel to be more responsive. `film_roll:resizing` happens before the size of all children are set so you can prepare the children for display. This is a coffeescript function, and it configures the carousel to resizes the height of all `img.resize` images to match the height of the `img.banner` image, which is designed to be full width:

```coffeescript
  configureCarouselSecondaryImages: ->
    $carousel = $ 'div.carousel'
    $banner = $carousel.find('img.banner')
    if $banner
      $carousel.on 'film_roll:resizing', ->
        $carousel.find('img.resize').height('').height $banner.height()
```

Since `film_roll:resizing` is called when the page loads *and* when the page resizes, this forces all images to be the same height as the banner image, no matter what their relative sizes. The banner image can adjust itself to the window of the device (using CSS and `max-width: 100%`), and the rest of the images can adjust to it. [Google for responsive images to learn more about it](https://www.google.com/search?q=responsive+images+max-width).

## Default CSS

Unless you specify no_css, FilmRoll adds the following css to the page header:

```css
.film_roll_wrapper {
   display: block;
   text-align: center;
   float: none;
   position: relative;
   top: auto;
   right: auto;
   bottom: auto;
   left: auto;
   z-index: auto;
   width: 100%;
   margin: 0 !important;
   padding: 0 !important;
   overflow: hidden;
   width: 100%;
 }
.film_roll_shuttle {
   text-align: left;
   float: none;
   position: relative;
   top: 0;
   left: 0;
   right: auto;
   bottom: auto;
   margin: 0 !important;
   padding: 0 !important;
   z-index: auto;
 }
 .film_roll_shuttle.vertical_center:before {
   content: '';
   display: inline-block;
   height: 100%;
   vertical-align: middle;
   margin-right: -0.25em;
 }
.film_roll_child {
  position: relative;
  display: inline-block;
  *display:inline;
  vertical-align:middle;
  zoom:1;
}
.film_roll_prev, .film_roll_next {
   position: absolute;
   top: 48%;
   left: 15px;
   width: 40px;
   height: 40px;
   margin: -20px 0 0 0;
   padding: 0;
   font-size: 60px;
   font-weight: 100;
   line-height: 30px;
   color: white;
   text-align: center;
   background: #222;
   border: 3px solid white;
   border-radius: 23px;
   opacity: 0.5;
 }
.film_roll_prev:hover, .film_roll_next:hover {
   color: white;
   text-decoration: none;
   opacity: 0.9;
 }
.film_roll_next {
   left: auto;
   right: 15px;
 }
.film_roll_pager {
   text-align: center;
 }
.film_roll_pager a {
   width: 5px;
   height: 5px;
   border: 2px solid #333;
   border-radius: 5px;
   display: inline-block;
   margin: 0 5px 0 0;
   transition: all 1s ease;
 }
.film_roll_pager a:hover {
   background: #666;
 }
.film_roll_pager a.active {
   background: #333;
 }
.film_roll_pager span {
   display: none;
 }
 .film_roll_pager a, a.film_roll_prev, a.film_roll_next {
   -webkit-box-sizing: content-box;
   -moz-box-sizing: content-box;
   box-sizing: content-box;
 }
```

Add it to your own css and disable with `no_css: true` when calling FilmRoll to improve performance.

##Troubleshooting

###Loading Failure (e.g. on iOS 8)

FilmRoll needs to measure the size of all elements to function. As a result, it is not completely configured until page load. If any other script fails or times out it could cause FilmRoll to fail. iOS 8 in particular is brittle in this regard. (In one instance Vimeo failed to load and caused FilmRoll to fail.) Use developer tools to watch your resources loading. Look for any failures. 

You can delay `film_roll.configureLoad` with a timeout by passing in an integer to the configure_load option:

```javascript
var film_roll = new FilmRoll({
  container: '#container_id',
  configure_load: 50
});
```

This will call `film_roll.configureLoad()` 50 milliseconds after the film roll is instantiated. _This may or may not mean the assets are ready!_

###Large images or slow loading pages

If you have a heavy set of images, the gallery can look empty while it loads. You can either style the child element to have an appropriate background (e.g. a gradient) while it is waiting, or you can use javascript to load high res pics later. E.g. populate your gallery with placeholder images and use [jQuery Lazyload](https://github.com/tuupola/jquery_lazyload) to load the images after the page loads. 

###Items aren't centering

If items aren't centering correctly, it is probably because you don't have child div's in side the parent div. For instance, calling FilmRoll on an unordered list has mixed results. Usually the centering will not work. You'll have to strip all normal css styling to get it to work. It will probably be easier to convert it to div > div format. 

If you do have divs inside a parent div, try temporarily giving a border to the child div to see what is going on. The child div may be centered, but its content may not be. 

If you think you have found a bug, report an issue. 

###Images disappear at the front or back

FilmRoll is really designed for content wider than the container. When you get to the end of a list of children, it rotates content ahead of time so there are no blank spaces during the subsequent animation. If your list is just wider than your container, or if your children are very wide compared to the width of the whole, you may see children disappear from one side before they appear on the other. This is expected behavior.

Eventually I will have a fix for this. In the meantime, repeat the children to fill out the list. It will still look like the smaller list rotating, and you will not have 'disappearances.'

###Double rows on start (shuttle width)

FilmRoll sets the shuttle (the the div that holds all elements and slides back and forth) to 10000 pixels wide until the page loads. When the page loads, the content is used to determine the appropriate width. If 10000 pixels is not enough for the content you will get two rows of children during page load. Try setting `shuttle_width` to a higher value. 

###Box shadow is cut off

jQuery does not measure the box shadow when it measures the height of child elements. If you want FilmRoll to adjust the height dynamically but also make the box shadow visible, set the FilmRoll height with a "+height" string. The integer should be the same as your box shadow height. So if your box shadow is `10px`, use `height: "+10"`. FilmRoll will add 10 pixels to the minimum height of the wrapper.

##Changelog

- **0.1.16:** (4/13/15) Position/offset, slide but no rotate for less than visible width, handle duplicate instances, force_buttons & force_rotate options
- **0.1.15:** (3/15/15) Prevent TouchSwipe link block
- **0.1.14:** (12/16/14) Millisecond delay option for configureLoad
- **0.1.13:** (12/15/14) Allow no prev/next buttons
- **0.1.12:** (7/18/14) Bower support
- **0.1.11:** (7/18/14) Swipe movement, height padding
- **0.1.10:** (7/18/14) Fix $.width change
- **0.1.9:** (4/17/14) Cache child widths, transit.js support
- **0.1.8:** (2/25/14) Options for hover, easing, and configure_load function
- **0.1.7:** (10/27/13) Full height screen support, better events, classes for CSS animations
- **0.1.6:** (10/27/13) Full screen support, height no longer required
- **0.1.5:** (10/22/13) Fix moveToIndex, add moveToChild, fix non scrolling usage
- **0.1.4:** (9/30/13) IE7 fix - still doesn't center right
- **0.1.3:** (9/13/13) Always use outerWidth
- **0.1.2:** (8/27/13) Added events
- **0.1.1:** (8/26/13) Fixes for load/reload mouse issues. Child margins.
- **0.1.0:** (8/21/13) Initial release

##Development

Fork the project on [github](https://github.com/straydogstudio/film_roll 'straydogstudio / FilmRoll on Github'), edit away, and pull.

FilmRoll is written in [CoffeeScript](http://coffeescript.org). To automatically compile to javascript, use the following command in the film_roll directory:

```bash
coffee -wc -o js/ coffee/*.coffee
```

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
