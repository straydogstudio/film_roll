#FilmRoll
**A lightweight jQuery carousel**


##Description

**FilmRoll** is a lightweight jQuery carousel that focuses on one item at a time, centering it in the view, regardless of the relative sizes of the carousel items.

[**SEE DEMO**](http://straydogstudio.github.io/film_roll)

---

##Features

- Centers one item at a time in the view
- Uses css classes for easy styling / transitions
- Provides previous / next buttons and pagination automatically
- Defaults to auto scroll with pause on hover
- Swipe is not yet available, but will be

##Usage

###Installation

- Download [jquery.film_roll.min.js](https://raw.github.com/straydogstudio/film_roll/master/js/jquery.film_roll.min.js) and place it in your scripts directory
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

Using non `<div>` tags as children is untested, but may work, depending on the tag and styling.

###Create

Create the FilmRoll instance on dom:ready:

```javascript
  jQuery(function() {
    film_roll = new FilmRoll({
         container: '#container_id',
         height: 560,
         prev: '#left_button_id',
         next: '#right_button_id',
       });
  })
```

###Configuration
**var film_roll = new FilmRoll({container: '#container_id', OPTIONS})**

Params:

- **:container** (Mandatory): The div that contains all elements that are to be displayed.
- **:height** (Mandatory - sort of) Set the height of the scroll container. The height of the tallest element by default. You may have flashing problems on load or cover up css effects if you do not set this.

Options:

- **:start_index**: The index of the first element to center
- **:pager**: Display pagination dots at the bottom of the carousel. True by default.
- **:prev**: The jquery selector for the previous button. Creates its own button by default.
- **:next**: The jquery selector for the next button. Creates its own button by default.
- **:scroll**: Automatically scroll the carousel. True by default.
- **:interval**: The automatic scroll interval. 4 seconds by default.
- **:animation**: The slide animation duration. 1/4 of interval by default.
- **:no_css**: Do not add [default css](#default-css) to page.
- **:shuttle_width**: The starting shuttle width until the page loads. Defaults to 10000. See [troubleshooting](#double-rows-on-start-shuttle-width).

###Examples
View the [project page for working examples](https://straydogstudio.github.io/film_roll).


###On load vs. dom:loaded

FilmRoll is written to be called on dom:ready. It inserts all markup before display and configures itself to resize itself once the content is loaded (after the window.load event) because it must have content to center an item on the page.

If, for some reason, you need to call FilmRoll on window.load, or create it using an in page script, trigger resize manually:

```javascript
film_roll_var.configureWidths()
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
        <div class="active film_roll_child">…</div>
        <div class="film_roll_child">…</div>
      </div>
    </div>
  </div>
```

Use these classes to apply styling and effects. See the [example page](https://straydogstudio.github.io/film_roll).

## Callbacks

FilmRoll provides the following callbacks. Unless otherwise noted, all events are triggered on the surrounding container that FilmRoll is initialized with:

- **film_roll:dom_ready**: When html content has been inserted but the page has not been loaded.
- **film_roll:before_loaded**: When the page has been loaded and **before** FilmRoll has set widths. (Just add an event to window.load to do something after.)
- **film_roll:deactivate**: When the in place form is deactivated
- **film_roll:moved**: When the children have been moved.
- **film_roll:reized**: When the FilmRoll has been resized.
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
   position: absolute;
   top: 0;
   left: 0;
   right: auto;
   bottom: auto;
   margin: 0 !important;
   padding: 0 !important;
   z-index: auto;
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

##TODO

- Swipe support for mobile
- Vertical carousels?

##Changelog

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
