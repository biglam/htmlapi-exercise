# Intro to Rails - Getting Rolling on Rails


This lesson is designed on the (Rolling With Rails)[http://oreilly.com/ruby/archive/rails.html] tutorial that introduced many early adopters of Rails to the framework.

The goal of the lesson is to show in very short form, some of the rapid-prototyping functionality that Rails gained quick popularity for.

This isn't the lesson you learn Rails - but a chance to see what some of the broad strokes of functionality is, and how it relates to what we've seen so far.


# What is Rails

Rails is the web application framework we've been building up to over the last few weeks.

It's focussed around the [MVC](http://en.wikipedia.org/wiki/Model–view–controller) pattern.

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

- in Sinatra we had (effectively) one "controller" - Rails lets us have many

[http://guides.rubyonrails.org/v4.2.4/](http://guides.rubyonrails.org/v4.2.4/)


# Rolling on Rails

Let's install Rails:

```
  gem install rails -v=4.2.4
```

Versions of Rails change quite rapidly, if you leave off the "-v", you'll get the latest version - so be specific if you want a specific version.

Rails includes some command-line tools, so if you're using `rbenv` to manage your Ruby you'll need to rehash.

```
  rbenv rehash
```

And let's build a sample application that's supposed to do three things:

  * Display a list of all recipes.
  * Create new recipes and edit existing recipes.
  * Assign a recipe to a category (like "dessert" or "soup").


## Required features

- Title - Same on all pages.
- Heading - Same on all pages.
- Table
  - Recipe - Clicking on the link takes us to a page showing a non-editable view of the recipe. The page has links to edit and save the recipe and to return to the listing page.
  - (delete) - Clicking on the link deletes the recipe from the database and from the page.
  - Category - Clicking on the link causes the page to be refreshed with only recipes in that category included.
  - Date - The date should be assigned by the system when a recipe is created or edited.
- Footer - Appears on all pages. NOTE: On the Category pages, the link on the left will be "Create new category." It should behave similarly to the "Create new recipe" link. The rest of the footer is the same on all pages.
  - Create new recipe - Clicking on the link takes us to a form to enter the recipe's name, description, and instructions, and to select a category to which to assign the recipe.
  - Show all recipes - Clicking on the link displays all recipes. This is used to restore the display after the list has been filtered by clicking on one of the Category links.
  - Show all categories - Clicking on the link takes us to a list view for categories with links on the page to edit and delete existing Category entries. (Footer has the "Create new category" link.)

That's all we have to go on.


# Create our app

```
  rails new cookbook

  cd cookbook

  rails generate scaffold Category name:string
  rails generate scaffold Recipe title:string instructions:text published_on:date

  rake db:migrate

  rails server
```

In your browser you can visit `http://localhost:3000/categories` and `http://localhost:3000/recipes`

That much functionality was a week's work once upon a time... it's now quicker (almost) than labelling columns in Excel...


# Rails Console

We can use the Rails console to interrogate our objects and their attributes, etc.

```
  rails c

  Category.all

  Recipe.all
```


## Add associations

To link our Recipe model and Category model together, we need to add a foreign key to the recipes table. We would have previously done this with a SQL query, but Rails gives us "migrations" to manage our database.

```
  # terminal
  rails g migration AddCategoryIdToRecipes category_id:integer
  rake db:migrate
```

```
  # app/models/recipe.rb
  belongs_to :category
```

```
  # app/models/category.rb
  has_many :recipes
```

We can play with this in the console.


## Update form with association

```
  # app/views/recipes/_form.html.erb
  <div class="field">
    <%= f.label :category_id, 'Category' %><br />
    <%#= f.number_field :category_id %><%# we are updating the category_id attribute, but rather than typing the ID in, it would be nice to have a drop-down of the names of the categories %>
    <%= f.select(:category_id, Category.all.map {|c| [c.name, c.id] }) %>
  </div>
```

But if we submit this, it doesn't save - Rails is protecting us from users altering forms and submitting unpermitted parameters by filtering for only those on the "whitelist".

We need to change the permitted parameters to include our new "category_id" field. This is in the "recipe_params" method in our controller:

```
  # app/controllers/recipes_controller.rb
  def recipe_params
    params.require(:recipe).permit(:name, :instructions, :published_on, :category_id)
  end
```


## Update views with association

```
  # app/views/recipes/show.html.erb
  <p>
    <b>Category:</b>
    <%= @recipe.category.name %>
  </p>
```

nice!


## Update views with association

```
  # app/views/recipes/index.html.erb
  <th>Category name</th>
  <td><%= recipe.category.name %></td>
```

oh noes... it broke... do we give up here?...

Look at the error... fathom it... glean information...

...then change it to:

```
  <%= recipe.category.name rescue nil %>
```

but that code smells a bit -- there's too much risk that a "rescue" like this could hide other errors.

Change it again to:

```
  <%= recipe.category.name if @recipe.category %>
```

This is better, but it can use some Rails help and change again to:

```
  <%= recipe.category.try(:name) %>
```


## Pretty it up a little

```
  # app/assets/stylesheets/application.css
  table {
    border-collapse:collapse;
    border:1px solid black;
  }

  table td {
    border:1px solid black;
  }
```


## Templating. Add footers, etc.

```
  # app/views/layouts/application.html.erb
  <!DOCTYPE html>
  <html>
  <head>
    <title>Online Cookbook</title>
    <%= stylesheet_link_tag    "application", :media => "all" %>
    <%= javascript_include_tag "application" %>
    <%= csrf_meta_tags %>
  </head>
  <body>
    <h1>Online Cookbook</h1>
    <%= yield %>

    <p>
      <% if controller_name == 'recipes' %>
         <%= link_to "Create new recipe", new_recipe_path %>
       <% else %>
         <%= link_to "Create new category", new_category_path %>
       <% end %>

       <%= link_to "Show all recipes", recipes_path %>
       <%= link_to "Show all categories", categories_path %>
     </p>
  </body>
  </html>
```


## Filtering in controller

```
  # app/controllers/recipes_controller.rb, index action
  @recipes = case
  when params[:category_id].nil?
    Recipe.all
  else
    Recipe.where(category_id: params.delete(:category_id))
  end
```


## Anything else?

"Rails is the next level in web programming, and the developers who use it will make web applications faster than those who don't. Ruby on Rails makes software development simple. It makes it fast. It makes it fun. And best of all? Rails is available, under an open source MIT license."


# BOOKMARK!!

http://guides.rubyonrails.org/v4.2.4/
