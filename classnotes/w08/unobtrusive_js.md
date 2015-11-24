# Unobtrusive JavaScript

Yesterday we did some basic, old-school JavaScript. But we've got code in our HTML (we even saw a little written inline, right inside an HTML tag!) and variables and functions defined in "global scope".

  - Which means anyone can access our functions
  - Which means anyone can **overwrite** our functions!!
  - Or we can overwrite other people's by accident

This is not really much separation of concerns!

We should aim to make apps where the behaviour of our app (especially if it's controlled by JavaScript) is away from the presentation of our app. We should aim to make apps that run as close as possible to how we want them to, no matter what device or browser they're running on. [1]


# Progressive enhancement vs graceful degradation

You can think of the front-end of our app a bit like a stack. A stack of component parts (like building bricks), that work together to form the whole.

- We've got HTML, but we've also got CSS, and JavaScript on top of it making it change.
- When you add a 'back-end' stack too, you have servers, and business logic, and databases, and more, all under the HTML providing it with support.

We can use the functionality of JavaScript to make our interfaces nicer, but we shouldn't rely on it for critical behaviour.

If we're validating user input, we should do that everywhere throughout the stack that valid data is needed. If we *only* validate in one bit of JavaScript, how are back-end components to *know* that the front-end validated it.

- If we ensure to develop an app that works as intended at the lowest point in the stack, we can be happier that it will work as intended on the lowest common denominator system, which means it'll be more resilient.
- If we then add fancy CSS and JavaScript (or any other components) on top of it, we are *progressively enhancing* our app.

The alternative is to make it as fancy and clever as we can, and then try to make it work when those things are taken away. This is *graceful degradation*.

  - It's demonstably harder to do
  - It's less likely to be successful
  - I don't like it

We recommend you approach your development with progressive enhancement; there's less to go wrong and it keeps your feedback cycle short.


# Modules

One common approach to avoiding clashing functions with other code is to organise your functionality in to "modules".

Instead of creating a bunch of things in our global scope, we create one global variable (which we *hope* still doesn't clash with someone else's variable) and put all our code in it.

```
  var myApp = myApp || {};
  myApp.reverse = function(val) {
                    return val.split('').reverse().join('');
                  }
```


# Closures

But we can also do this so that we don't have ANYTHING in the global scope -- and if we don't have anything in global scope, we can't clash with any other code, and nothing can clash with us.

Do you recall the problem we had when looping all the radio buttons while looking at the 'change' event? How did we solve it? We created an 'anonymous' function, and we invoked it immediately.

```
  (function() {
    var i;
    var foo = function(i) {
      console.log('variable `i` is currently ' + i);
    };
    for(i=1;i<10;i++) {
      foo(i);
      }
  })();
```

We can use this to keep stuff completely hidden from the global scope. It's not something we'll *use* often at the level of JS we're writing, but just be aware of it, as you will see it in the 'real world' when looking at source code of other apps.


# Exercise: make the 'disco' unobtrusive

Let's take our code from yesterday's JS lesson, and make sure it's unobtrusive, and that it's organised to allow us to progressively enhance.

- Move JS code to a separate JS file
- Create a module for our code
  - move the function and variables into it as properties
- Remove the `onclick` property and target the element directly (add an ID?)
- Add event listener to the button to call the function when clicked
- Ensure the code works! (the JS needs to be called *after* the document has loaded, otherwise you'll get errors about "Cannot read property of null")


# jQuery: aren't all these JS complications a pain?

We've been scrabbling around with our document, and it's been kind of a pain to get elements, hasn't it?

And what happens if we open our page in IE?

  - `addEventListener` isn't supported in browsers older than IE8.
  - Some older browsers insist on the last parameter of the addEventListener being supplied.

Remember, one of the concepts of unobtrusive JS is to try to work as we intend no matter what browser or device.

We could fix these problems ourselves, using "feature detection" conditional logic, or we could let someone else write a library to do the work for us -- and since we're lazy...


## Fixing unobtrusively with jQuery

jQuery is a library that makes JavaScript nicer to work with.

  - It smooths out cross-browser inconsistencies
  - Makes it simpler and more functionality around access to DOM elements
  - Provides utilities for common tasks, like AJAX and some pretty stuff.


## Initial setup

We can either download jQuery and host it on our own website, or we can use a 'Content Delivery Network'.

```
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
```


# jQuery basics.

The `$` is your friend. It's the jQuery Swiss army knife.

  - You'll use it to get elements to work with.
  - And to get jQuery objects, which support more methods than regular DOM objects.
  - Mention $ naming convention (`var $foo`)
  - It's also got some utility methods on it.

You'll need to use http://api.jquery.com a lot. A LOT. Bookmark it!


# Exploring the dollar

We can use jQuery to simplify getting elements.

  - by tag name `$('li')`
  - by ID `$('#name')`, `$('#greeting')`
  - by class `$('.number')`.

We have easier ways of managing event listening (and jQuery handles browser quirks)

  - `$('#greeting').click(function() { alert("You just clicked the greeting!"); });`
  - `$('.number').click(myApp.alerty);`

Note: Be aware of "event bubbling" -- this is not jQuery-specific, it's JS.

  - `$('ul').click(myApp.alerty);`

We can change elements.

  - `$('#greeting').text('Lol');`
  - `$('#greeting').addClass('big');`
  - `$('#greeting').removeClass('big');`

jQuery has iterator functionality *like* Ruby's Enumerable.

  - `$.each(myApp.colours, function(i, item) { console.log(item); });`

Some wizz-bang effects that are built in.

  - `$('ul').append('<li>whoa!</li>');`
  - `$('ul').slideUp();`
  - `$('ul').slideDown();`
  - `$('.number').slideToggle();`
  - `$('li').slideToggle();`


## Small tangent into JS funniness

But sometimes things don't work the way you expect. If we add another `li` with a class of 'number', we'd expect the click handler we added earlier to work. But it doesn't.

  - `$('ul').append('<li class="number">007</li>');`

The solution is to register listeners of events higher up the DOM, and use 'delegation' to respond to events on their children. Instead of registering a listen on elements with the class 'number', we'll register a listener to the 'ul' element, for when any of its children with the class 'number' are clicked (convoluted, nah?).

  - `$('ul').on('click', '.number', myApp.alerty);`

Again, like event-bubbling, this isn't jQuery's fault, it's just how the DOM works. But because jQuery makes the DOM easier to work with, we're more likely to encounter quirks like this.




[1]: http://en.wikipedia.org/wiki/Unobtrusive_JavaScript
