# Film Roll
**A lightweight jQuery carousel**


##Description

**film_roll** is a lightweight jQuery carousel that focuses on one item at a time, centering it in the view, regardless of the relative sizes of the carousel items.

[**SEE DEMO**](http://film_roll.github.io/)

---

##Features

- Centers one item at a time in the view
- Uses css classes for easy styling / transitions
- Provides previous / next buttons and pagination automatically
- Defaults to auto scroll with pause on hover
- Swipe is not yet available, but will be

##Usage

###Installation

- Download [jquery.film_roll.min.js](https://github.com/straydogstudio/film_roll/js/jquery.film_roll.min.js) and place it in your scripts directory
- Link it in your web page: `<script src="js/jquery.film_roll.js"></script>`

###Markup

film_roll expects a parent div with children div elements:

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

###Configuration
**var film_roll = new FilmRoll({container: '#container_id', OPTIONS}) **

Params:

- **container** (Mandatory): The div that contains all elements that are to be displayed.

Options:

- **:start_index** The index of the first element to center
- **:pager** Display pagination dots at the bottom of the carousel. True by default.
- **:height** Set the height of the scroll container. The height of the tallest element by default. (Note: You may have to specify this to account for css effects.)
- **:prev** The jquery selector for the previous button. Creates its own button by default.
- **:next** The jquery selector for the next button. Creates its own button by default.
- **:scroll**: Automatically scroll the carousel. True by default.
- **:interval**: The automatic scroll interval. 4 seconds by default.
- **:animation**: The slide animation duration. 1/4 of interval by default.
- **:no_css**: Do not add [default css](#default-css) to page.

###Examples
View the [project page for working examples](https://film_roll.github.com).

A basic example:

```html
  jQuery(window).load(function() {
  	film_roll = new FilmRoll({
  	     container: '#container_id',
  	     height: 560,
  	     prev: '#left_button_id',
  	     next: '#right_button_id',
  	   });
  })
```

###On load vs. dom:loaded

Currently you need to call film_roll on window.load. Centering an element requires images to be loaded. Markup and sizing/centering will be split soon so page flicker doesn't happen.

###Styling

film_roll wraps all children with two divs, and adds the `active` class to the centered element:

```html
  <div id="film_roll">
    <div class="film_roll_wrapper">
      <div class="film_roll_shuttle">
        <div class="active">
          <a href="..."><img src="..."> </a>
        </div>
        <div>
          <a href="..."><img src="..."> </a>
        </div>
      </div>
    </div>
  </div>
```

Use these classes to apply styling and effects. See the example page.

## Default CSS

Unless you specify no_css, film_roll adds the following css to the page header:

```html
	<style type='text/css'>
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
	 </style>
```

##TODO

- Swipe support for mobile
- Vertical carousels?

## Development

Fork the project on [github](https://github.com/straydogstudio/film_roll 'straydogstudio / film_roll on Github')

##Authors, License and Stuff

Code by [Noel Peden](http://straydogstudio.com) from [Northwood Manufacturing](http://northwoodmfg.com) and released under [MIT license](http://www.opensource.org/licenses/mit-license.php).
