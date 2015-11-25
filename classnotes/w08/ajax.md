# Objective

- Students understand what AJAX is
- Students understand what's going on under the hood
- Students understand how they can use it to make their apps more responsive
- Students understand the concept of a callback
- Students understand how they can use it to check for new updates.


# AJAX!

What is AJAX?

  - Asynchronous JavaScript And XML

We use it to do stuff in the background

  - Such as making our pages feel more responsive by not requiring a full page load.
  - Or pulling in content after our page has loaded.

It's important to know what acronymns stand for, but it's more important to understand what they *mean*.


## Asynchronous

Literally means "outwith time" -- and is used in computing in relation to processes that don't occur on regular intervals or dependent on other processes finishing, but instead run in their own time and finish whenever they're finished.

By default, AJAX works with asynchronous operations, but you *can* use it to make synchronous calls...


## JavaScript

The 'J' is fairly obvious, given our topic at the moment. The specific use of JavaScript in AJAX is to make web requests in script, and then perform operations dependent on the response.

It's like having a little JS browser inside the browser.


## XML

Extensible Markup Language is a text format language that describes a set of rules for describing text files that are both human- and machine-readable.

If you look at an XML document, it looks very much like HTML. It was a very popular format for data in the late 90's and early 2000's, although its verbosity and complexity have seen it fall out of use in large part.

When AJAX was first used, XML was generally expected to be the format for the response data. Nowadays JSON is much more common; but the response to web requests can be *anything*.


## Summary

So "AJAX" mean "Asynchronous or Synchronous JavaScript and XML or some other data format in response" :-)


# AJAX Requests

An AJAX request consists of a few things.

  - We need a URL to call, and maybe some data to go with it.
  - We need a callback function: something that runs when we get our data back.
  - Generally, we need two: one that runs on success, and one that runs on failure.


## Jumping in

Let's build a simple HTML page for a stocks page. And a simple Sinatra app to give me a quote for a given stock symbol.


### Starting point code

- Unzip it
- Don't look at the Ruby! Let's reverse-engineer it.

```
  # terminal
  gem install sinatra sinatra-contrib yahoofinance json
```

Run it:

- Visit http://localhost:4567
- Tour the app:
  - Home page. Pretty boring.
  - It's got a form. Where does it submit to?
  - It posts to a location, which then redirects us to that page.
  - And loading that page shows us a stock quote.


### What's wrong with that?

Nothing! It works just fine!

But... what if the user loads a page, and then walks away to get a coffee?

  - When they come back, it'll be out of date. And not obviously out of date.

We could make it autorefresh with pure HTML.

```
  # views/layout.erb
  <meta http-equiv="refresh" content="10">
```

But this is kinda ugly. If the web server is slow, then they could come back to an error page.

And what if the user's trying to do something, like type into a text box and we refresh it out from under them?

Note: remove the meta refresh tag before moving on!


## JS page refreshing

So maybe we could just make it update via JavaScript.

  - But... JavaScript is effectively single-threaded?
  - And we saw it lock up the browser, and the page, when a script starts to run -- it has to finish before the browser gets control again
    - So if this was a more complex website, doing lots of stuff, there's going to be lots of waiting by the user
  - Network access is soooo SLOOOOOOW. We'd have a lot of pauses.
  - And means your other code can't run

Here's some code that shows what happens when a JS takes ten seconds to complete.

```
  // js code to block the browser for 10 seconds
  var now = new Date();
  var currentDate = null;
  do { currentDate = new Date(); } while (currentDate-now < 10000);
```


# AJAX!

It's just a web request! But instead of it originating from the web browser, it's originating from our code.

The browser still makes the request, but it's driven by our JS - not by clicking links or submitting a form.

A little like me getting coffee. I could go out and get myself a cup...

  - But then you're all stuck here, waiting for me to return.
  - Empty space.
  - And if I get distracted, and have to go grab something else while I'm outside...
  - Still empty space. More empty space (for you while you wait).

But what if I ask my friend to get me coffee?

  - I can keep on teaching. I just don't have my coffee yet.
  - I can do other stuff, simpler stuff, until I'm caffeinated.
  - And if I'd asked my friend to grab something from the table outside, then I can carry on teaching in the meanwhile, meantime, meanwhilst.


## So how do we do it?

Browsers give you a thing called the `XMLHttpRequest` object... mostly... (IE, I'm looking at you...)

  - We need an endpoint we can call.
  - And we should (ideally) request JSON data back.
  - Now we've got it back, we need to do something with it.
  - And we need to do something different if it fails.

```
  # public/application.js
  function ajaxGetRequest(endPoint) {
    var xmlhttp;

    // code for IE7+, Firefox, Chrome, Opera, Safari, etc. Older/other browsers *may* bork..
    xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function() {
      if (xmlhttp.readyState == XMLHttpRequest.DONE ) {
        console.log(xmlhttp.responseText); // comment this if you're happy with the response and don't need it in the console
        if(xmlhttp.status == 200) {
          console.log('that all worked just fine');
        } else if(xmlhttp.status == 404) {
          console.error('There was an error 404');
        } else {
          console.error('something else other than 200 or 404 was returned')
        }
      }
    }

    xmlhttp.open("GET", endPoint, true);
    xmlhttp.setRequestHeader('X-Requested-With', 'XMLHttpRequest'); // header to let the server know this request came from AJAX rather than a browser refresh
    xmlhttp.send();
  }
```

We'll test it first with some hard-coded calls, and set them to fire off two- and three-seconds after the page loads.

```
  # public/application.js
  setTimeout(function() {
    ajaxGetRequest("http://localhost:4567");
  }, 2000);
  setTimeout(function() {
    ajaxGetRequest("http://localhost:4567/wat/errorz/here");
  }, 3000);
```

Refresh and see what you see in the console. What happens if you set them both to two-seconds?... refresh a couple of times, and you should see their order of response change (sometimes the server takes fractionally longer to serve the first, so the second request overtakes it). This proves that they're not blocking each other... they're "asynchronous".

Note: you can remove those two tests... delete or comment the `setTimeout` calls.

So now let's hook our function into the form button. Write an event listener to capture the submission of the form - to check it works, just console log for now.

```
  # public/application.js
  $('#stock_search').on("submit", function(e) {
    e.preventDefault();
    console.log("Form submitted");
  });
```

Gah! There's that `Uncaught TypeError: Cannot read property 'addEventListener' of null` error message again. What was the cause of this? How do we fix it?

It *can* be fixed by moving the JavaScript tag to the bottom of the file HTML, but *most* people would expect to find all your scripts included in the header.

The preferred solution in that case is to wrap *all* your JS in an event handler -- the event to listen for is for when the browser has finished loading the DOM.

```
  # public/application.js
  document.addEventListener("DOMContentLoaded", function(event) {
    $('#stock_search').on("submit", function(e) {
      e.preventDefault();
      console.log("Form submitted");
    });
  });
```

Now your JS can stay in the header, and the functionality should work as intended; logging a message to the console when we submit the form.

Note: jQuery gives us a terser, and more compatible way of doing the same thing.

```
  # public/application.js
  $(document).ready(function() {
    ...
  });
```

or *even* terser (**why** do we keep having several ways to do the same things??)

```
  $(function() {
    ...
  });
```

Use one of these jQuery "document ready" functions to wrap *all* your DOM-operating code.


With that working, we can replace the `console.log()` with the 'real' code.

```
  # public/application.js
  $('#stock_search').on("submit", function(e) {
    e.preventDefault();
    var stockSymbol = $('#stock_symbol').val();
    var url = '/' + stockSymbol;

    ajaxGetRequest(url);
  });
```


# Console output

So let's take a breath, and look at what is in the console. What does it look like? Where has it come from? What code in the Sinatra app generated it? What can we do with it in our JS?

This is JSON data, generated by the conditional code in the Sinatra controller code (which checked for `.xhr?` requests). In the response, we can treat this as a JavaScript object (hence the name), and access its property values, and do whatever we like with it.

We could even take those values, and update the content of the page!...


# Using jQuery to do the same thing

But first, we're going to replace our function with the jQuery code for making AJAX calls.

```
  # public/application.js
  // replaces `ajaxGetRequest(url);`
  $.ajax({
    url: url,
    type: 'GET',
    success: function(data) {
      console.log('that all worked just fine');
    },
    complete: function(response) {
      console.log(response.responseText);
    }
  });
```

Our 25-line function has been replaced by 10 lines of jQuery. And we get the re-assurance of cross-browser compatability being handled by the library (and, arguably, a clearer syntax). We could make it even shorter by using alternate syntax, or the `$.get()` function... but we'll leave it here for now.

As you can see, we pass the jQuery `ajax()` function an object literal that configures options for the XHTTP request, and also optional functions to call in the event of the request completing, and being a successful status (we could pass another function to perform other operations in the event of errors).

Note: You may also see the "function chaining" syntax that looks along the lines of `$.get('http://google.co.uk').complete(function(){console.log('complete!')}).fail(function(){console.error('failed!')}).always(function(){console.log('finished either way!')})`


# Updating the DOM

In our `views/quote.erb` file, we have elements for displaying various components of the stock quote, and conveniently (!) they have IDs assigned to them. So we can use those IDs to target them in the DOM.

Instead of just logging that a request was successful, let's replace the values in those elements with the values from our response data.

```
  # public/application.js
  success: function(data) {
    $('#name').text(data['name'])
    $('#symbol').text(data['symbol'])
    $('#lastTrade').text(data['lastTrade'])
    $('#time').text(data['time'])
    $('#date').text(data['date'])
    $('#updatedAt').text(data['updatedAt'])
  },
```

That's not very DRY... can we do better?

```
  # public/application.js
  function updateElement($el, content) {
    $el.text(content);
  }

  success: function(data) {
    var attributes = ['name', 'symbol', 'lastTrade', 'time', 'date', 'updatedAt'];
    for (var i = 0; i < attributes.length; i++) {
      updateElement($('#' + attributes[i]), data[attributes[i]]);
    }
  },
```


# Let's make this better.


## Empty the input

The user has submitted their choice, and the AJAX has run successfully, but what they typed is still in the input. What can we do to fix this?

Let's hook into the `complete` property, and clear the contents of the input.

```
  # public/application.js
  complete: function(response) {
    console.log(response.responseText);
    $('#stock_symbol').val('');
  }
```


## Progress indicator

It's always nice to be able to let users know when there's some AJAX running.

```
  # views/quote.erb
  <p id="updatemessage" class="hidden">Updating...</p>
```

```
  # public/styles.css - these are already in the file, but are here to show what's needed

  #updatemessage {
    margin-left: 30%;
    margin-right: 30%;
    border-radius: 20px;
    border: 1px solid #aa3;
    padding: 5px;
    padding-left: 25px;
    background: url('1-1.gif') 5px 5px no-repeat;
    background-color: #ee9;
  }

  .hidden {
    display: none;
  }
```

```
  # public/application.js
  function startLoading() {
    $('#updatemessage').slideDown();
  }

  function endLoading() {
    $('#stock_symbol').val('');
    $('#updatemessage').slideUp();
  }
```

```
  # public/application.js - a new `beforeSend` property in the object and an altered `complete`

  $.ajax({
    url: url,
    type: 'GET',
    beforeSend: startLoading,
    success: function(data) {
      var attributes = ['name', 'symbol', 'lastTrade', 'time', 'date', 'updatedAt'];
      for (var i = 0; i < attributes.length; i++) {
        updateElement($('#' + attributes[i]), data[attributes[i]]);
      }
    },
    complete: endLoading
  });
```


## Highlight changes

Sometimes, the updates to the DOM made by JavaScript can be very subtle and easy for the user to miss. We shall "flash" a colour change on each element to grab the user's attention.

We can either write out own JS to manipulate the colours.

```
  function updateElement($el, content) {
    $el.text(content);

    var up = true;
    var level = 15;
    var step = function () {
      var hex = level.toString(16);
      $el.css('background-color', '#FAFA' + hex + hex);
      if (up) {
        if (level > 0) {
          level--;
          setTimeout(step, 25);
        } else {
          up = false;
          level = 1;
          setTimeout(step, 25);
        }
      } else if (level < 15) {
        level += 1;
        setTimeout(step, 25);
      } else {
        $el.css('background-color', '#FFF');
      }
    };
    setTimeout(step, 25);
  }
```

Or use a combination of JS and CSS.

```
  # public/styles.css - these are already in the file, but are here to show what's needed

  .flash{
    -moz-animation: flash 1s ease-out;
    -moz-animation-iteration-count: 1;
    -webkit-animation: flash 1s ease-out;
    -webkit-animation-iteration-count: 1;
    -ms-animation: flash 1s ease-out;
    -ms-animation-iteration-count: 1;
  }

  @-webkit-keyframes flash {
      0% { background-color:none;}
      50% { background-color:#FAFA00;}
      100% {background-color:none;}
  }

  @-moz-keyframes flash {
      0% { background-color:none;}
      50% { background-color:#FAFA00;}
      100% {background-color:none;}
  }

  @-ms-keyframes flash {
      0% { background-color:none;}
      50% { background-color:#FAFA00;}
      100% {background-color:none;}
  }
```

```
  function updateElement($el, content) {
    $el.text(content);
    $el.addClass("flash");

    setTimeout( function(){
      $el.removeClass("flash");
    }, 1000); // Timeout must be the same length as the CSS3 transition or longer or the transition will mess up
  }
```

Which approach do you think better? Why?


# What else can we do with AJAX?

  - We can check for users posting new content, like Twitter showing '3 new tweets' at the top if you leave a page open.
  - We can do *partial rendering*, where we render part of the page on the server and send the new content to the browser.
    - Could do this for pagination.
    - Could do this for switching between tabs.
    - Can reduce server load times, because we don't have to generate the entire page all at once.
  - We can send data back to the server. In our example, we've done it as part of the URL, via a GET request, but we could have used the `data` property instead.


# What's the point?

  - Smaller web requests
  - Makes pages feel more 'alive'
  - Lets us update pages without forcing the user to hit refresh

