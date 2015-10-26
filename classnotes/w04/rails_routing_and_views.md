# Rails Routing and views


In this lesson, we are going to talk about "routing".

We've said that Rails is focussed around the MVC pattern, and this seperation of areas of concern results in a rather large structure to gain familiarity with.

We're going to start our way into Rails by looking at the views that get shown to the user, and the route that browser requests take through to get to the views.

This should be familiar from the Sinatra work we've done, but is going to have a few subtle differences.

```
                                          -----> Model <----> DB
                                         |         |
            response        request      |         |
   Browser <-------- router -------> controller <--
                             GET         ^
                             PUT         |
                             POST         -----> view <----> html/images/css/js
                             DELETE
```

When a user makes a request to the browser, the web-application needs to know what content to show them.

Let's compare with code that we have previously written.

In Sinatra we defined the routes within our controller action.

```
  get '/recipes' do
    @recipes = Recipe.all
    erb :'recipes/index'
  end

  get '/recipes/new' do
    @recipe = Recipe.new
    @categories = Category.all
    erb :'recipes/new'
  end
```

A "route" being the combination of the path that was requested, and the HTTP verb that was used to request that path.

Rails modifies this approach, and has a seperate routing engine that hands requests to controller actions.

# Make a new rails app to play

```
  # terminal
  rails new routing_app
  cd routing_app
```

We're going to get familiar with Rails routing by making a couple of "static" pages, the likes of which all web sites seem to have.

We'll need pages for "About Us", "FAQs", and "Terms and Conditions".

If you run a Rails server and look at the result of making a request to that path without having done anything to make it work, you'll get an error telling you that Rails doesn't recognise that route.

> No route matches [GET] "/about_us"


## We need to define the routes that our application will respond to

The configuration of Rails' routes in held in the file `config/routes.rb` (wow! It's like the filename is self-documenting).

In `config/routes.rb` delete all the comments (you can read them later, or in the documentation, but for today they'll just be in the way) and replace with.

```
  get '/about_us', to: 'home#about_us'
```

We're saying here "`GET` requests that come in for the path `/about_us` will be routed to the `home` controller's `about_us` action".

Let's have a look at this running now. Fire-up a Rails server and look at the result of making a request to that path again.

```
  rails s
```

Visit `http://localhost:3000/about_us` in the browser. What do you see? Another error... but what does it mean?

> uninitialized constant HomeController


## We need something for Rails to root to

The routes file says that GET requests to `/about_us` will be routed to an action in `home` -- and the convention is to create a `HomeController` class defined in a `home_controller.rb` file.

```
  # terminal
  touch app/controllers/home_controller.rb
```

```
  # app/controllers/home_controller.rb
  class HomeController < ApplicationController

    ## This is a controller action called about_us
    def about_us
      # it's deliberate that there's no code in here... but we should have a helpful error when we request the URL again
    end

  end
```

Now Rails is telling us that it is `Missing template home/about_us` and that it searched in `".../routing_app/app/views`.


## Views

Just like in Sinatra, we have a directory for views, and all of our user-interface structure goes in there. The expectation of Rails is that it will find a subdirectory with the same name as the controller. Inside that, it expects to find view files with the same name as action; and a matching file will be the one that gets rendered.

In Sinatra we had to be explicit about which view would be rendered with ERB. Rails makes lots of assumptions for us, and this "convention over configuration" is often attributed to magical behaviour.

Note: We *can* over-ride all the defaults pretty easily, and you can render any view you like from any action with extreme ease.

```
  # terminal
  mkdir app/views/home

  touch app/views/home/about_us.html.erb
```

Rails uses ERB too, but the file naming convention is a little more verbose. I bet there's a reason for that... I wonder if it'll become apparent as we get more familiar with Rails...


## Let's add some more routes

We had a couple of other routes we wanted our app to respond to. Let's follow the same process of adding them to the `routes.rb` file, and route them to their own actions (although, what would you expect to see if you routed two requests to the same action?)

```
  get '/faqs', to: 'home#faqs'
  get '/terms_and_conditions', to: 'home#terms'
```

As you can see, the action doesn't have to be *exactly* the same as the path -- it doesn't actually even need to be nearly at all the same. The point of the routing engine is to allow you to wire things however you want; but for an easy life, we frequently try to keep things named the same (mostly because we're lazy).


## So now we need to add these actions to our controller

```
  # app/controllers/home_controller.rb:

  def faqs
  end

  def terms
  end
```

## And views

```
  # terminal
  touch app/views/home/faqs.html.erb
  touch app/views/home/terms.html.erb
```

Populate some content in those new views. Make web requests to those paths in your browser, and ensure that you see the text you expect.


## Layouts like Sinatra

In Sinatra we had to create the layout. But in Rails, a default file is there already - `app/views/layouts/application.html.erb`,

Add some navigation links to it:

```
  <nav>
    <ul>
      <li><a href='/about_us'>About Us</a></li>
      <li><a href='/faqs'>Faqs</a></li>
      <li><a href='/terms_and_conditions'>Terms & Conditions</a></li>
    </ul>
  </nav>
```

## Homepage

We call the "landing page" of our web app the "Root route", and we need to define it in the routes file. It can be any existing controller action, or you could have a dedicated action for your home page.

```
  root to: 'home#about_us'
```


## Rake Routes

We can see all of the routes defined in our application by running `rake routes` at the terminal.

Rails is also very helpful, and shows all the available routes in the browser whenever a routing error occurs in development.



http://guides.rubyonrails.org/v4.2.4/routing.html
