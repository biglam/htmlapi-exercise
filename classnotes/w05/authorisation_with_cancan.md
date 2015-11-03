# Authorization with CanCan(Can)

If authentication is about making sure you know the identity of the person accessing your site, authorisation is about determining **what** they can do.

CanCan is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in a single location (the Ability class) and not duplicated across controllers, views, and database queries.

The currently maintained version is called '[CanCanCan](https://github.com/CanCanCommunity/cancancan)', since Ryan Bates ceased maintaining the original source of CanCan.

We will first need an app to work in which has authorisation, let's use the app from the "authorisation with Devise" lesson, but let's tweak it to have some CRUD functionality too.

Let's add a resource, which we will control access to - a Recipe would be good and familiar!:

```
  # terminal
  rails g scaffold Recipe name:string instructions:text
  rails g scaffold_controller Recipe name:string instructions:text # Devise seems to be over-riding the Rails generators, so running this to get a default Rails-style controller
```

Add the CanCan gem to our Gemfile.

```
  # Gemfile
  gem 'cancancan'
```

```
  # terminal
  bundle install
```


A simple way to determine who can do what, is to give your users a 'role' (guest, user, admin, etc.). To do this, we will create a migration which will add the column 'role' to our users table.

```
  # terminal
  rails g migration AddRoleToUsers role:string
```

``
  # db/migrate/TIMESTAMP_add_role_to_users.rb
  class AddRoleToUsers < ActiveRecord::Migration
    def change
      add_column :users, :role, :string
    end
  end
```

Now run your migration.

```
  # terminal
  rake db:migrate
```

And update your user model to include:

```
  # app/models/user.rb
  def role?(role_to_compare)
    self.role.to_s == role_to_compare.to_s
  end
```

Note: Never allow the 'role' to be set in a form (unless you are **really** sure you have secured it). It would be far too easy for a user to escalate their permissions by altering the value of the role assigned to them in the form.


We will use cancan to manage the abilities of users.

```
  # terminal
  rails g cancan:ability
```

Now in the generated file add:

```
  # app/models/ability.rb
  class Ability
    include CanCan::Ability

    def initialize(user)
      user ||= User.new
      if user.role? :admin
        can :manage, :all
      else
        can :read, Recipe
      end
    end
  end
```

The `can` method has lots of options, read about them here: [https://github.com/CanCanCommunity/cancancan/wiki/defining-abilities]().

We can check abilities in controllers and views with `can?` and `cannot?`.

For individual records, to determine, for instance, if the current user has the 'destroy' ability for a given instance of a Recipe.

```
  # any Rails controller or view
  can? :destroy, @recipe
```


Or whether they can perform actions on the class as a whole; can the current user 'create' a Recipe:

```
  # app/views/recipes/index.html.erb
  <% if can? :create, Recipe %>
    <%= link_to "New Recipe", new_recipe_path %>
  <% end %>
```

In controller actions we can authorize with `authorize!`:

```
  # app/controllers/recipes_controller.rb #show action
  authorize! :show, @recipe
```

That will raise a permission denied error if the user cannot 'show' the particular Recipe.


Or we can use a shortcut helper, which will both load the controller's resource (@recipe in the RecipesController for instance) and authorize it for every action:

```
  # app/controllers/recipes_controller.rb
  class RecipesController < ApplicationController
    load_and_authorize_resource

    # ... rest of controller code
```

Now if we try and access a secure page using the user role, we will be displayed a CanCan error page. We can redirect from this error page, and add an alert message, by updating our ApplicationController to include this method:

```
  # app/controllers/application_controller.rb
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: "You can't access this page"
  end
```


# Notes on 'role'

The process we use in this lesson is just one of a gazillion ways you can use CanCan to determine whether users are able to perform a task.

A 'role' is a very limited way of assigning users access rights, and is very similar to the Access Control List (ACL) approach, but it's a very common starting point for permissions; but only a start.

Generally, in real life applications, our permissions will need to be a little more flexible that just "admins can do this, users can do that"; we will quickly have situations where users can access *some* records, but not others (for instance, they may be able to view orders of their own customers, but not orders for other users' customers), and you will need to build the logic into the ability.rb file to support this.

Giving users a 'role' is just an extra layer of granularity we can build upon - but it certainly should not be viewed as the ending point.


# The ACL is Dead - Zed Shaw
http://vimeo.com/2723800


