# The DOM and the Web Browser


## JavaScript vs the DOM

The **Document Object Model**, or DOM, is the interface that allows you to programmatically access and manipulate the contents of a web page (document). It provides a structured, object-oriented representation of the individual elements and content in a webpage with methods for **getting** and **setting** the properties of those objects.

It also provides methods for **adding** and **removing** such objects, allowing you to create dynamic content on the client-side rather than the server-side without reloading the page! Exciting!

The DOM also provides an interface for dealing with events, **allowing you to capture and respond to user or browser actions**.
t.


### In short:

The DOM lets us do two things:

- Manipulate the document, add, remove, retrieve, edit/update, etc.
- Run code when 'things' happen


## Javascript vs the browser

Javascript is not the same as the web browser. And the web browser is not the same as JavaScript. You can run your Javascript code without a web browser -- there are easy-to-install terminal consoles (like IRB).

Generally, since most of our JS is destined for use in web pages, we want to write JavaScript that runs in the browser, (and we'll all use Chrome for consistant results).



## Event driven programming

We've written a couple of different kinds of programs so far. Imperative ones, and Object-Oriented ones.

- **Imperative** code that starts at the top line, and chugs down through it until it finishes.
- **Object oriented** programs, where we define a bunch of objects and then our code jumps around as necessary.

But we've also written **event-driven** programs, though we haven't called them that.

- When our web server runs, it sets up our app and then just sits there.
- It's not until something happens - an event - our visit to the web page - that our code runs.

We can define events on elements, and what JS to run when those events happen.


## addEventListener

The javascript `addEventListener()` method attaches an event handler to a specified element). We select that element using some property that lets us pluck it from the DOM -- an 'ID' is a good property, as they should be unique in the DOM, so we know which element we're getting.

Note: We can select elements using other properties (like 'class', or anything else), which would enable us to add listeners to more than one thing. We'll do this later...


### Syntax

The syntax for adding event listeners is:

```
  # js console
  element.addEventListener(event, function, useCapture);
```

- `element` in this case is the DOM object that you want listener to operate on (you have to get it first)
- The first parameter is the `type of the event` (like "click" or "mousedown").
- The second parameter is then name of the `function we want to call` when the event occurs. It optionally takes an argument of the event that was captured.
- The third parameter is a boolean value specifying whether to use `event bubbling` or `event capturing`. This parameter is optional, (we'll go into more detail later).


## Click events / Mouse events

Javascript allows us to capture and use click events.

Open the Javascript Console in Chrome and let's open the javascript console (`cmd + alt + j` or  "More Tools > Developer Tools > Javascript Console").

You can bind an event to listen for single-clicks inline (directly on an element) like this:

```
  # html
  <button onclick="alert('Hello CX3!');">I'm an inline button!</button>
```

However, inline JavaScript like this is considered "bad practise", and packs of dogs will hunt you down and point and laugh at you if you *ever* use it.

It's better to get the element using javascript:

```
  # js console
  var element = document.getElementById("event_click");
```

Looking for click events is a very common event in web browsers. Let's look at 4 kinds of click events.

Note: We'll log the responses to the console -- 'alert' messages are not very (leet)[http://en.wikipedia.org/wiki/Leet].


### "click"

```
  # js console or click_events.html source
  var element = document.getElementById("event_click");
  element.addEventListener("click", function() {
    console.log("I've been clicked!");
  });
```


### "dblclick"

```
  # js console or click_events.html source
  var element = document.getElementById("event_dblclick");
  element.addEventListener("dblclick", function() {
    console.log("I've been double-clicked!");
  });
```


### "mousedown"

```
  # js console or click_events.html source
  var element = document.getElementById("event_mousedown_mouseup");
  element.addEventListener("mousedown", function() {
    console.log("The mouse has been pressed down!");
  });
```


### "mouseup"

```
  # js console or click_events.html source
  var element = document.getElementById("event_mousedown_mouseup");
  element.addEventListener("mouseup", function() {
    console.log("The mouse has been lifted up!");
  });
```

Note: You can attach more than one event to an element too. See what happens if you attach *all* the above events to one of the buttons :-o


## Key events


### "keypress"

```
  # js console or key_events.html source
  document.getElementById("key_event").onkeypress = function() {
    console.log("key pressed!");
  };
```

Note: The `addEventListener()` method is not supported in Internet Explorer 8 and earlier versions. If you *need* to support older browsers, then the above is another method of creating an event listener (although this syntax means only being able to have *one* listener per element).

We can seperate keypresses into two listeners - one for when a key is pressed down, and one for when a key is let up.


#### "keydown"

```
  # js console or key_events.html source
  var element = document.getElementById("key_event");
  element.addEventListener("keydown", function() {
    console.log("key down!");
  });
```


#### "keyup"

```
  # js console or key_events.html source
  var element = document.getElementById("key_event");
  element.addEventListener("keyup", function() {
    console.log("key up!");
  });
```


## Hover events


### "mouseover" and "mouseout"

Take a look at the code for the image of Bill Murray (it's got some basic styling):

```
  # hover_events.html
  <img id="bill" src="http://fillmurray.com/200/301" />
```

And the corresponding javascript:

```
  # js console or hover_events.html source
  var bill = document.getElementById("bill");

  bill.onmouseover = function() {
    console.log("mouseover #bill");
    this.setAttribute('src', 'http://fillmurray.com/200/300');
  }

  bill.onmouseout = function() {
    console.log("mouseout #bill");
    this.setAttribute('src', 'http://fillmurray.com/200/301');
  }
```

In the context of the event, `this` means the element that the event is operating on (so the image tag in this example). And any document element can have events bound to it, and we can always use the console to see what's going on.

Aside: Try to see what "this" is in the context of clicking different things -- for instance, the body of the document.

```
  # hover_events.html
  body = document.getElementsByTagName("body")[0];
  body.onclick = function() {
    console.log(this);
  }
```


### "mousemove"

For a slightly more complicated example, let's have a look at how we can follow the movements of the mouse.

```
  # js console or hover_events.html source
  var element = document.getElementById("mouseHover");
  element.addEventListener("mouseover", function(e) {
    this.addEventListener("mousemove", function(e) {
      console.log(e.pageX, e.pageY, (e.pageY/500))
      this.style.opacity = (e.pageY/500);
      this.style.filter  = 'alpha(opacity=' + (e.pageY/500) + ')';
    });
  });

  document.getElementById("mouseHover").addEventListener("mouseout", function(e) {
    console.log("you've left the element");
  });
```

In this code we are creating a listener for `this` which will log the 'x' & 'x' coordinates of our mouse and change the `style` property of the element.


## Form events

Like click events, forms are very common things to have to deal with on a website. We can attach to events that happen in relation to elements on a form (in addition to the events we've seen so far)


### "focus"

```
  # form_events.html
  var element = document.getElementById("key_event");
  element.addEventListener("focus", function(e) {
    console.log("focus!");
  });
```


### "blur"

```
  element.addEventListener("blur", function(e) {
    console.log("blur!");
  });
```


### "change"

Look at the JS code regarding the radio button even listeners. What do you expect it should do?

```
  # form_events.html
  var radios = document.getElementsByClassName("radio_event")
  for( var i = 0; i < radios.length; i++ ) {
    radios[i].addEventListener("change", function() {
      console.log('Radio ' + i + ' selected');
    });
  }
```

Click a couple of radio buttons and see what happens? Does it say "Radio 2 selected", "Radio 1 selected", etc? No?... why not?

The fix for this is to make our code a little more complex -- we will use a construct called a "closure" (different from the programming language 'Clojure') to allow us to ensure the value of `i` is 'correct' for each function.

```
  # form_events.html
  for( var i = 0; i < radios.length; i++ ) {
    (function(i) {
      radios[i].addEventListener("change", function() {
        console.log('Radio ' + i + ' selected');
      });
    })(i);
  }
```


### "submit"

```
  # form_events.html
  document.getElementById('form_event').addEventListener("submit", function(e) {
    e.preventDefault();
    console.log("Form submitted");
  });
```


## Window events

As well as interacting with elements inside the page, like clicking items or interacting with forms. You can also access information when you change the browser window.


### "resize"

```
  window.onresize
```


### "scroll"

```
  window.onscroll
```


## Resources

- MDN: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference?redirectlocale=en-US&redirectslug=JavaScript%2FReference
- JavaScript puzzlers: http://javascript-puzzlers.herokuapp.com

