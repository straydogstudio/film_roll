#FilmRoll
**A lightweight jQuery carousel**


##Description

**FilmRoll** is a lightweight jQuery carousel (8.4 kb) that focuses on one item at a time, centering it in the view, regardless of the relative sizes of the carousel items.

[**SEE DEMO**](http://straydogstudio.github.io/film_roll)

---

##Features

- Centers one item at a time in the view
- Uses css classes for easy styling / transitions
- Provides previous / next buttons and pagination automatically
- Defaults to auto scroll with pause on hover
- Supports [full screen usage](http://straydogstudio.github.io/film_roll/fullscreen.html)
- Yet to be implemented:
    - Swipe for mobile
    - Simple external link using classes/ids (For now [see Javascript below](#using-javascript))

##In The Works

- Examples for:
    - Responsive images
    - CSS animtaions (2D and 3D)
- Swipe support for mobile
- Simple external links

##Usage

###Installation

- Download [jquery.film_roll.min.js](https://github.com/straydogstudio/film_roll/releases) and place it in your scripts directory
- Link it in your web page: `<script src="js/jquery.film_roll.js"></script>`

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

Options:

- **:animation**: The slide animation duration. 1/4 of interval by default. (See **interval** option.)
- **:configure_load**: If true, configure widths immediately (use if instantiating FilmRoll with the page load event.) If false, configure width on the window load event. If a function, immediately call the function. False by default. Without this option FilmRoll assumes it has been instantiated on DOM ready ([jQuery.ready()](http://api.jquery.com/ready/)) and it will schedule its width configuration to run on page load. 
- **:easing**: `swing` by default. jQuery also provides `linear`. [jQueryUI](http://api.jqueryui.com/easings/) provides more.
- **:height**: Set the height of the film_roll wrapper (which sits inside the container.) Options are:
    - **Not set** (default): The wrapper will be the height of the container (100%), with a min-height of the tallest element.
    - **Integer/string**: Set the height directly. Can be an integer (pixels) or a string ('75%'.)
- **:hover**: If true, pause scroll on hover. If false, ignore hover. If 'scroll', scroll the carousel on hover. True by default.
- **:interval**: The automatic scroll interval. 4 seconds by default. To turn off the automatic scroll, see the **scroll** option.
- **:next**: The jquery selector for the next button. Creates its own button by default. (See **prev** option.)
- **:no_css**: Do not add [default css](#default-css) to page. You will want to include it otherwise.
- **:pager**: Display pagination dots at the bottom of the carousel. True by default.
- **:prev**: The jquery selector for the previous button. Creates its own button by default. (See **next** option.)
- **:resize**: Re-center the carousel on window resize. True by default. Set to false to perform your own logic before calling `film_roll_variable.resize();`.
- **:scroll**: Automatically scroll the carousel. True by default.
- **:shuttle_width**: The starting shuttle width until the page loads. Defaults to 10000. See [troubleshooting](#double-rows-on-start-shuttle-width).
- **:start_height**: A starting height to give the carousel. Use only if you are having content flashes.
- **:start_index**: The index of the first element to center
- **:vertical_center**: Center children vertically in the container. Requires a browser with **:before** CSS pseudo class support. This is useful for a full screen carousel.

###Examples
View the [project page for working examples](http://straydogstudio.github.io/film_roll).

###On load vs. dom:loaded

FilmRoll is written to be called on dom:ready. It inserts all markup before display and configures itself to resize itself once the content is loaded (after the window.load event) because **it must have content to center an item on the page**.

If, for some reason, you need to call FilmRoll on window.load, or create it using an in page script, pass in the `configure_load: true` option to immediately call the relevant code:

```javascript
var film_roll = new FilmRoll({
    configure_load: true,
    container: '#container_id',
  });
```

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

## Using Javascript

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

## Callbacks

FilmRoll provides the following callbacks. Unless otherwise noted, all events are triggered on the surrounding container that FilmRoll is initialized with:

- **film_roll:dom_ready**: When html content has been inserted but the page has not been loaded.
- **film_roll:moving**: When shuttle animation begins.
- **film_roll:moved**: When shuttle animation has finished.
- **film_roll:resizing**: Before FilmRoll measures the size of all content. The shuttle div is given the class `film_roll_resizing` during measurement. Called when the page has been loaded *and* when the page resizes. 
- **film_roll:resized**: When the FilmRoll has been resized.
- **film_roll:activate**: When a child element is activated. Triggered on the child.

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

##Changelog

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

Code by [Noel Peden](http://straydogstudio.com) from [Northwood Manufacturing](http://northwoodmfg.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
