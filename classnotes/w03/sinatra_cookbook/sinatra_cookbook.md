# Sinatra Cookbook

# What are we doing today?

There's three very clunky things about the Sinatra apps we've created so far:

One of the clunkiest features is that when we query the DB, we take the results and put them into an array of hashes (or a single hash for the "show" page), and access the hash keys in the views.

Also quite clunky, and a bit "stinky" (have we talked about "[code smells](http://en.wikipedia.org/wiki/Code_smell)" yet?), is the amount of raw SQL we find ourselves writing in our `main.rb`, and furthermore, the fact that we end up writing a awful lot of code generally in there - we have seven default RESTful routes for each of the DB tables we want to map into our application - and we'd also have to have multiple view files (we need a `view` for each of our tables).


## Patterns to tidy this up

How can we fix these smells?

Firstly, let's do the simplest thing, and chop up our controller code into different files - one for each DB table. We'll stick each of these files into a "controllers" folder, and don't forget to require them in your `main.rb` file. We can also create separate view folders for each table.

Then, how about we map those hashes of fieldnames that the PG gem gives us, onto Ruby objects. This way we can use code like `<%= recipe.name %>` rather than `<%= recipe["name"] %>`; and we can leverage extra functionality of the Ruby objects, by moving the SQL into the model itself, and create methods with names like "find" and "save" to encapsulate common functionality.


## Practice App

Let's practice this approach by building *another* cookbook (by this point, we should be familiar with the structure of cookbook apps, so we only need to think about the code, not the "problems" of creating a cookbook).

Our cookbook is going to have Recipes which can belong to a Category (and maybe, if we have time and inclination, Ingredients)

Let's start with Categories.

Create a `main.rb` file and general Sinatra structure (don't forget the `controllers` folder and files for managing the categories table)


```
  mkdir cookbook
  cd cookbook
  touch main.rb
  mkdir public
  touch public/reset.css
  touch public/styles.css
  mkdir controllers
  touch controllers/categories_controller.rb
  mkdir views
  touch views/layout.erb
  touch views/home.erb
  mkdir views/categories
```

Populate the `main.rb` file with your Sinatra app.

```
  require 'pry-byebug'
  require 'sinatra'
  require 'sinatra/reloader' if development?
  require 'pg'

  require_relative 'controllers/categories_controller'

  get '/' do
    erb :home
  end
```

Setup your app's layout.

```
  # views/layout.erb
  <!doctype html>
  <html lang='en'>
    <head>
      <meta charset='utf-8'>
      <link rel='stylesheet' href='/reset.css'>
      <link rel='stylesheet' href='/styles.css'>
      <title>Cookbook</title>
    </head>

    <body>
      <header>
        <h1><span class='branding'>Cookbook</span> &ndash; Greed is Good</h1>
      </header>

      <nav>
        <ul>
          <li><a href='/'>Home</a></li>
        </ul>
      </nav>
      <%= yield %>
    </body>
  </html>
```

Put some "splash" content in your home page.

```
  # views/home.erb
  <p>Welcome to another great cookbook</p>
```

Fire-up your app, and you should see the layout and home page.


## Defining Categories

What fields should our Category model have?

  - id
  - name

Create a database, and a SQL file to maintain our DB, and put the commands in it to create the categories table.

```
  # terminal
  createdb cookbook
  touch cookbook.sql
```

```
  # cookbook.sql
  drop table categories;
  create table categories (
    id serial4 primary key,
    name varchar(255) not null
  );

  insert into categories (name) values ('starters');
  insert into categories (name) values ('mains');
  insert into categories (name) values ('desserts');
```

```
  # terminal
  psql -d cookbook -f cookbook.sql
```

Note: first time you run this, you'll get an error that "table "categories" does not exist" - because it doesn't until this file runs! Next time you run the file, you won't see that error.


## Starting our development cycle

Add a link to the layout navigation which will show all the categories.

```
  # views/layout.erb
  <li><a href='/categories'>Categories</a></li>
```

And a matching action in the controller with accompanying sql-querying functionality.

```
  # controllers/categories_controller.rb
  get '/categories' do
    sql = "SELECT * FROM categories"

    @categories = run_sql(sql)
    erb :'categories/index'
  end

  private
  def run_sql(sql)
    conn = PG.connect(dbname: 'cookbook', host: 'localhost')
    begin
      result = conn.exec(sql)
    ensure
      conn.close
    end

    result
  end
```

And write the view to show all the categories.

```
  # terminal
  touch views/categories/index.erb
```

```
  # views/categories/index.erb
  <ul>
    <% @categories.each do |category| %>
      <li>
        <%= category["name"] %>
      </li>
    <% end %>
  </ul>
```

Refreshing the browser should show our link to the categories; and clicking it should show all the seeded data.


## But this is still stinky!

We said we wanted a Ruby model ('model' is what how we shall refer to Ruby classes which map to database tables); but we're still using the hash that PG returned.

Create a folder to store our models, and make a model for categories - don't forget to require it in your `main.rb` file.

```
  # terminal
  mkdir models
  touch models/category.rb
```

```
  # models/category.rb
  class Category

    attr_accessor :id, :name

    def initialize(params={})
      self.id = params['id']
      self.name = params['name']
    end

  end
```

```
  # main.rb
  require_relative 'models/category'
```

Note the naming conventions - singular models, plural controllers.

This model has the functionality to take a hash of arguments, and map them to attributes. So we could change our controller to instanciate a new one of these objects for each of the hashes returned in the SQL query; or we could move the SQL query to the model, and have a method that returns "all" categories (a much 'better' approach!).

```
  # models/category.rb
  def self.all
    results = run_sql("SELECT * FROM categories")
    results.map { |result| self.new(result) }
  end

  private
  def self.run_sql(sql)
    conn = PG.connect(dbname: 'cookbook', host: 'localhost')
    result = conn.exec(sql)
    conn.close
    result
  end

  # controllers/categories_controller.rb
  get '/categories' do
    @categories = Category.all
    erb :'categories/index'
  end
```

We'll need to change the view file now, to use the attributes of the model, rather than the hash keys.

```
  # views/categories/index.erb
  <% @categories.each do |category| %>
    <li>
      <%= category.name %>
    </li>
  <% end %>
```

So now everything should be working the same as far as the end result in the browser is concerned. But we're getting to a point of having much better encapsulation of our code.


## Out of the fying pan

So we've now got a Ruby model, which loads all of itself from a DB table. The reason we did this was to get rid of crufty code from the controller, and we can probably predict that it's easy enough to add other methods to map to the other six default actions of the controller.

But...

Won't this just introduce lots of duplication of code when we add new models?

Will *every* model now have to have the DB connection, and all the SQL?

Before we go further down this rabbit hole, is there any way we can anticipate avoiding this problem?


## Inheritance

We've talked about inheritance as a way of sharing functionality between classes (the other way being mixing in modules) - what functionality could we take out of our Category model and move into a base class that our models could inherit from?

- The DB connection and `run_sql` method, for a start
  - Examining that code, it has the table name in it, which will be different for every 'model' in which we tried to reuse the code. So we'd need to make the table name variable.
- The initialize method; it just takes a hash, and maps all the keys to attributes
  - That means we'd have to share the attribute-definition functionality.

Let's tweak our Category model, and create a new base-class for it to inherit from.


```
  # terminal
  touch models/db_base.rb
```

```
  # models/db_base.rb
  class DBBase
    attr_accessor :id

    def self.attributes(attrs)
      @attributes = attrs
      attrs.keys.each do |attr|
        attr_accessor attr
      end
    end

    def self.get_attributes
      @attributes
    end

    def self.table_name
      @table_name ||= begin
        case
          when name[-1] == 'y'
            name[0...-1] + 'ies'
          when name[-1] == 'x'
            name + 'es'
          else
            name + 's'
        end.downcase
      end
    end

    def attributes
      self.class.get_attributes
    end

    def table_name
      self.class.table_name
    end
  end
```

```
  # main.rb - ensure to require this before the models that inherit from it
  require_relative 'models/db_base'
```

The Category model should end up looking like this.

```
  # models/category.rb
  class Category < DBBase
    attributes name: :string
  end
```

The code we move from Category to DBBase ends up looking like this after it's been tweaked to be reusable.

```
  def self.run_sql(sql)
    conn = PG.connect(dbname: 'cookbook', host: 'localhost')
    result = conn.exec(sql)
    conn.close
    result
  end

  def self.all
    results = run_sql("SELECT * FROM #{table_name}")
    results.map { |result| self.new(result) }
  end

  def initialize(params={})
    params.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def run_sql(sql)
    self.class.run_sql(sql)
  end
```

The DBBase class has taken the shared functionality of talking to the DB, but it needs to know which table to talk to (and each sub-class will need a different table name). We've also added the functionality to define which fields each sub-class has, and what their data-type is - this could be handy later!


## Adding functionality

So now we want to start building the rest of the functionality of our controller; we need to be able to create, update, and delete categories, as well as being able to retrieve single ones by ID.

First, let's add some links to our index page, and then build out the controller actions to make those work.

```
  # views/categories/index.erb
  <a href='/categories/new'>new category</a>

  <ul>
    <% @categories.each do |category| %>
    <li>
      <%= category.name %>
      <a href='/categories/<%=category.id%>/edit'>edit</a>
      <form action='/categories/<%=category.id%>/delete' method='post'>
        <button>delete</button>
      </form>
    </li>
    <% end %>
  </ul>
```

Let's set up a route and action to handle a new Category.

```
  # controllers/categories_controller.rb
  get '/categories/new' do
    @category = Category.new
    erb :'categories/new'
  end
```

And that will need a view to render - and since it's a form, and we're going to want to create and edit, we might as well put our form fields in a partial file so we can reuse it.

```
  # terminal
  touch views/categories/new.erb
  touch views/categories/_form.erb


  # views/categories/new.erb
  <form action='/categories' method='post'>
    <%= erb :'categories/_form' %>

    <button>add</button>
  </form>


  # views/categories/_form.erb
  <dl>
    <dt>
      <label for='category_name'>Name:</label>
    </dt>
    <dd>
      <input id='category_name' type='text' name='category[name]' value='<%=@category.name %>' autofocus>
    </dd>
  </dl>

  <div class='clear_both'></div>
```

note: We had to define a new `@category` object in our controller action, because our form is expecting there to be one - if it wasn't, we'd get "Undefined method" errors on 'NilClass'.

The names of those fields correspond to the keys that will end up in the params hash, so make sure you name them accurately - any typos in field names will end up with confusing results.

We need to now set up the action to handle the submission of the form, and we'll write this to instanciate a new Category object, and ask it to save itself.

```
  # controllers/categories_controller.rb
  post '/categories' do
    @category = Category.new(params[:category])
    @category.save
    redirect to('/categories')
  end
```

But we don't have any functionality to save categories. Where should it go?

Into our DBBase class is the answer!

```
  # models/db_base.rb
  def save
    if id.nil?
      sql_fields = []
      sql_values = []
      attributes.each do |attribute, type|
        sql_fields << attribute
        sql_values << sql_sanitize(self.send(attribute), type)
      end

      sql = "INSERT INTO #{table_name} (#{sql_fields.join(', ')}) VALUES (#{sql_values.join(', ')}) RETURNING id"
      self.id = run_sql(sql).first['id']

    else

      sql_fields_and_values = attributes.map do |attribute, type|
        "#{attribute} = #{sql_sanitize(self.send(attribute), type)}"
      end

      sql = "UPDATE #{table_name} SET #{sql_fields_and_values.join(', ')} WHERE id = #{sql_sanitize(id, :integer)}"
      run_sql(sql)
    end
  end

  def sql_sanitize(value, type)
    self.class.sql_sanitize(value, type)
  end

  def self.sql_sanitize(value, type)
    case type
      when :string
        "'#{value.to_s.gsub("'", "''")}'"
      when :text
        "'#{value.to_s.gsub("'", "''")}'"
      when :integer
        value.to_i
      when :decimal
        value.to_f
      else
        raise "Unrecognised data type `#{type}`"
    end
  end
```

Let's not dwell too much on this code ;-) There are always times we find ourselves trusting tools we've received from others (all the gems we've used so far!). Suffice to say - if we're saving a new record, the method inserts into the DB, and if we're saving an existing record, it runs an update.

I'd suggest coming back to this method later at leisure, and seeing if you can figure out what it does.


## Rinse and repeat

The controller functionality to edit an existing record is very similar to creating, but the major difference is this time we have an ID of a record we want to retrieve from the DB, so we will need some functionality in our DBBase class to find it.

```
  # controllers/categories_controller.rb
  get '/categories/:id/edit' do
    @category = Category.find(params[:id])
    erb :'categories/edit'
  end
```

```
  # models/db_base.rb
  def self.find(id)
    result = run_sql("SELECT * FROM #{table_name} WHERE id = #{sql_sanitize(id, :integer)}").first
    self.new(result) if result
  end
```

```
  # terminal
  touch views/categories/edit.erb
```

```
  # views/categories/edit.erb
  <form action='/categories/<%=@category.id%>' method='post'>
    <%= erb :'categories/_form' %>

    <button>update</button>
  </form>
```

The submission for the edit form needs its controller action, and one more piece of DBBase behaviour to update the attributes of an existing object.

```
  # controllers/categories_controller.rb
  post '/categories/:id' do
    @category = Category.find(params[:id].to_i)
    @category.update_attributes(params[:category])
    redirect to("/categories")
  end
```

```
  # models/db_base.rb
  def update_attributes(attrs)
    attrs.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    save
  end
```


## Deleting

We're going to call our model's delete functionality "destroy" - mainly because that's the name of the method we're going to use when we move into Rails - and there's no sense using one name now, and another tomorrow!

```
  # controllers/categories_controller.rb
  post '/categories/:id/delete' do
    Category.find(params[:id]).destroy
    redirect to('/categories')
  end
```

```
  # models/db_base.rb
  def destroy
    run_sql("DELETE FROM #{table_name} WHERE id = #{sql_sanitize(id, :integer)}")
  end
```


## Result

We've ended up with much cleaner code:

- We have a separate controller file which contains only actions for the Category model; we could presumably create a `recipes_controller` if we wanted to add recipes to our cookbook now
- We have a Category model which has a couple of bits of configuration information, and all its functionality is hidden in the DBBase class - it's hidden, because once it's working, we'll never want to be tripping over it again.
  - We could even imagine a situation where the configuration in the model is redundant; we *could* guess the table name from the model name (it's just pluralised, after all), and we *could* find out the attributes by asking the database.
- Now new functionality has a "home" - a place it *should* be. We need to think less about where we put code, as we start to get into the habits of always putting it in the same places (depending on whether it's Model, View, or Controller logic).


