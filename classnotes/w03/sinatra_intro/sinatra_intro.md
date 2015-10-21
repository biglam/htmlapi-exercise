# Sinatra

Sinatra is a light-weight Ruby web framework.

It handles serving pages for requests, but leaves pretty much everything else to us

[http://www.sinatrarb.com]()

Sinatra is a Gem, so to install it is simple.

```
  gem install sinatra sinatra-contrib
```

We've also installed the "[sinatra-contrib](https://github.com/sinatra/sinatra-contrib)" gem, for some common extensions to Sinatra we might find useful.


## Example from Sinatra website

To get running, we'll make a "Hello World" with Sinatra.

Create a Ruby file, and populate it with the following code.

```
  require 'sinatra'

  get '/hi' do
    "Hello World!"
  end
```

Then run it from the terminal.

```
  ruby hi.rb
```

Visit [http://localhost:4567/hi] and see Sinatra in action.

Let's have a look at the four lines of code we wrote.

Firstly, we require the Sinatra functionality into our app.

Then, we use a keyword `get`... now, that's not a Ruby keyword... so what's going on?

This is a method provided by Sinatra's DSL to describe routes. This make the definition of Sinatra apps a bit more "natural language" (ubiquitous).

The method `get` takes an argument of a matching url path pattern, and a block of code to call if any `GET` HTTP requests match the path.

- There are corresponding methods for POST, PUT, PATCH, DELETE, etc... - we'll mostly just stick to GET and POST for now, since that's what our browsers natively support.

The return value of the block becomes the content (at least) of the response sent back to the browser.

So the upshot is; when a GET request is made to `/hi`, our app will generate a reponse of `"Hello World!"`, and that's what our browser will display.


## Expand the functionality of the app

```
  require 'pry-byebug'
  require 'sinatra'

  get '/hi' do
    "Hello World!"
    binding.pry
  end
```

We can use pry as we did in our command-line apps (although we need to stop and start our Sinatra app to see it work - hence it's worth adding a `require 'sinatra/contrib/all' if development?` line)

Note: Be aware of the fact that the debugger will appear in the terminal console window, not in the browser. Also, if you use any `puts` or `print` calls, their output will appear on the terminal console, not in the browser.

What path would need to be matched to have just a homepage at the root of our website? '/' is 'root', just like in the terminal file system.

```
  get '/' do
    'this is the homepage'
  end
```

Visiting the URL `http://localhost:4567` in a browser should show you the text returned from the block.


## Getting user input

While interacting with a web site, users need to be able to provide information. One of the ways we can get this is to capture parameters from the path in the URL.

We do this by defining the path with placeholder strings with colons in front of them (which makes them look like a symbol). This string is used as the key in a hash returned when we call `params`, and the value associated with it is whatever value was in the path.

```
  # capture parameters from the path
  get '/name/:first' do
    "your name is : #{params[:first]}"
  end

  # this could keep on going
  get '/name/:first/:last/:age' do
    "your name is #{params[:first]} #{params[:last]} and you are #{params[:age]} years old"
  end
```

It's important to note that this syntax forms a pattern that must be unique in the application. If you have two routes that match the same pattern, the first one wins.

```
  get '/name/:winner' do
    "#{params[:winner]} is the winner!"
  end

  get '/name/:loser' do
    "sorry, #{params[:loser]}, you lose :-("
  end
```

The previous code might be better expressed with unique paths and HTTP methods that describe the behaviour.

```
  get '/winner/:name' do
    "#{params[:name]} is the winner!"
  end

  get '/loser/:name' do
    "sorry, #{params[:name]}, you lose :-("
  end
```

Note: Users can also send data to us in the querystring of the URL, and in the data of form submissions. We'll get to that later.


## What is HTML injection?

**Beware of user inputs**

All values provided by a user, however they get to the web server, should be viewed with great suspicion.

Malicious users have the same ability to interact with your website as do legitimate users. If you do not 'sanitize' all user inputs, you run the risk of allowing malicious content further into the core of your application.

Users can provide input view form submissions, or the querystring. They can have functionality to upload files, and even data drawn from a database should be considered as 'user' input, and to be sanitized before using.

```
  # multiply two numbers and show the result
  get '/multiply/:x/:y' do
    result = params[:x].to_f * params[:y].to_f
    "the result is #{result}"
  end

  # where have we seen this before?... ah! Calc-U-L8R!
```
