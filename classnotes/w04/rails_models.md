# Rails models

We're going to explore the Rails features that enable us to work with database persistance and how Rails "models" objects.

When we first hooked Sinatra to a database, we created a "movie" listing app. Today, we'll point Rails at the same database to experiment with some existing data.


# Movies app

We shall create a new Rails app, and we need to tell Rails that we want it to configure itself for a PostgreSQL database.

```
  rails new movies -d postgresql
  cd movies
```


# Rewiring the database

Rails' defaults are everywhere. When we create a new app, it assumes we'll want a database, and configures itself with one of the same name as the app. But we don't want that today, so we need to change it.

Edit `database.yml` to alter the DB name of the development database to be the same as "movie_app" from Sinatra 'movies with db' app. This isn't something we **normally** do in Rails, but it's very good to know that we can, because you may want to tweak your database settings occasionally.


## What is that '.yml' file?

[YAML](http://en.wikipedia.org/wiki/YAML) is a data serialization language which is both human readable and computationally powerful. Essentially, it's a text file data store (like XML or CSV). It's the data format that Rails uses for lots of its configuration settings.

YAML files are indicated with a `.yml` file extension.


# First models

Just like in Sinatra, we'll create a Ruby class to map our database records to. Rails already gives us a folder structure to store models, so we'll put a new file in there.

```
  touch app/models/movie.rb
```

Add the code to define our `Movie` model.

```
  # app/models/movie.rb
  class Movie < ActiveRecord::Base
  end
```

## What is "ActiveRecord"?

We can see our `Movie` model is inheriting from `ActiveRecord::Base`, but what *is* that?

 *  An (ORM)[en.wikipedia.org/wiki/Object-relational_mapping] - (but what's an 'ORM'?!)

   > "An object that wraps a row in a database table or view, encapuslates the database access, and adds domain logic on that data". _Martin Fowler_

It makes the easy SQL stuff trivial, and the hard SQL stuff possible.

Each table in our database will be mapped to one Ruby class (there is such a thing as Single Table Inheritance though, but it's not for whimsy...)

Columns in the tables map to methods in the classes (automatically; 'magically').

[http://guides.rubyonrails.org/v4.2.4/active_record_querying.html]()


## Working by 'Magic'

Launch a Rails console by typing and investigate the `Movie` model's behaviour.

```
  # rails console
  Movie.first
  Movie
  Movie.count
  Movie.all
  Movie.all.class # take close note of the type of object that ActiveRecord queries return
  Movie.where(id: 1) # make sure the id exists! - you should be able to see them in the results of `Movie.all`
  Movie.find(1)
```

Note the difference that `.where()` returns an array, while `.find()` returns a single object - recall the clunkyness of having to do this manually in Sinatra?

All of these methods are given to us by the functionality inherited from ActiveRecord.


## More DB Queries

We can now do the majority of our DB querying by using ActiveRecord methods, rather than having to write SQL ourselves (although we still can, if we *have* to).

Conditional clauses can be specified with the `.where()` method. I has many different syntaxes, but they all result in the same returned value: an instance of an `ActiveRecord::Relation`.

```
  # rails console
  Movie.where(["year in (?)", %w(1999 1994 1986)])
  Movie.where(["year in (:years)", years: %w(1999 1994 1986)])
  Movie.where(year: %w(1999 1994 1986))
```

Other SQL clauses generally have a matching ActiveRecord method -- if you know what you want to achieve in a SQL command, check the documentation for how to do it "The Rails Way".

```
  # rails console
  Movie.order(:genre)
  Movie.order('genre DESC')
```


## Joining the dots

One very powerful feature of all these ActiveRecord methods is that they can be chained together to build one SQL query behind the scenes.

```
  # rails console
  Movie.where(year: %w(1999 1994 1986)).order(:genre)
```


## Create and retrieve

The singular best way to get familiar with Rails' ORM is to play with it. It is a layer of abstraction that *can* seem like we're giving up control, but as we gain familiarity with it, it turns into an extremely powerful tool to allow us to be fantastically productive.

So let's play! We'll create and save a couple of records to our database.

```
  # rails console
  m = Movie.new
  m.title = "Star Wars"
  m.year = 1977
  m.save
  Movie.last

  m = Movie.new(title: "The Empire Strikes Back")
  m.save
```

The `.new()` method above instanciates a new object, but we have to call `.save()` to write the changes we've made to the database.

But if we *know* that we just want to create a record in the database in one step, we can use the `.create()` method.

```
  # rails console
  m = Movie.create(title: "The Return of the Jedi")
  Movie.last

  m = Movie.find_by_title("Star Wars")  # old syntax - not preferred, but you might see it in example code online
  m = Movie.find_by(title: "Star Wars") # new syntax - preferred in Rails 4.x
```


## Update and delete

```
  m = Movie.last
  m.update(title: "Star Wars: A New Hope", genre: "space opera")
  Movie.last

  m.destroy
  Movie.last
```

There is a `.delete()` method, but we're going to only use `.destroy()` as it does more that just fire a DB query to delete the record.


# Further study

ActiveRecord is a large topic, so get comfortable and familiar practicing these simple steps, and then push into the documentation to try out unfamiliar features.


