# Film Roll
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

Using non `<div>` tags as children is untested, but may work, depending on the tag.

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
- **:shuttle_width**: The starting shuttle width until the page loads. Defaults to 10000. See [troubleshooting](#troubleshooting).
- **:expand**: True or false. By default, if the content width is between 1 and 2 times the width of the container, FilmRoll copies the children on both left and right sides to prevent blanks from appearing. Element ids are mangled so they do not repeat. Setting this to true or false will force this either way. 


###Examples
View the [project page for working examples](https://straydogstudio.github.io/film_roll).


###On load vs. dom:loaded

FilmRoll is written to be called on dom:ready. It inserts all markup before display and configures itself to resize itself once the content is loaded (after the window.load event.)

If, for some reason, you need to call FilmRoll on window.load, or create it using an in page script, trigger resize manually:

```javascript
film_roll_var.configureWidths()
```

###Styling

FilmRoll takes the following markup:

```html
  <div id="film_roll">
    <div class="active">...</div>
    <div class="active">...</div>
  </div>
```

and wraps all children with two divs, adds the class `film_roll_child` and a style element to the children, and adds the 'active' class to the centered child:

```html
  <div id="film_roll">
    <div class="film_roll_wrapper">
      <div class="film_roll_shuttle">
        <div class="active film_roll_child" style="position:relative; display:inline-block; vertical-align:middle">…</div>
        <div class="film_roll_child">…</div>
      </div>
    </div>
  </div>
```

Use these classes to apply styling and effects. See the example page.

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
   margin: 0px;
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
   margin: 0px;
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

###Shuttle width

FilmRoll sets the shuttle (the the div that holds all elements and slides back and forth) to 10000 pixels wide until the page loads. When the page loads, the content is used to determine the appropriate width. If, for some reason, 10000 pixels is not enough, and you get a strange flash on page load, try setting `shuttle_width` higher. 

##TODO

- Swipe support for mobile
- Vertical carousels?

## Development

Fork the project on [github](https://github.com/straydogstudio/film_roll 'straydogstudio / FilmRoll on Github')

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) from [Northwood Manufacturing](http://northwoodmfg.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
