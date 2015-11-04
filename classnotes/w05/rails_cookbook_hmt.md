# Rails Cookbook HMT

Did anyone notice any limitation to the HABTM association between the Recipe and Ingredient models?

The biggest is surely that there is no way to say *how much* of any given ingredient is needed on each recipe.

It would be much better to have a `Quantity` model, which not only recorded the ingredient_id and recipe_id, but also how much was needed.

```
  # terminal
  rails g scaffold Quantity ingredient_id:integer recipe_id:integer quantity:string
```

Alter the models to use the new association.

```
  # app/models/recipe.rb
  # delete or comment the `has_and_belongs_to_many :ingredients`
  has_many :quantities
```

```
  # app/models/ingredient.rb
  # delete or comment the `has_and_belongs_to_many :recipes`
  has_many :quantities
```

```
  # app/models/quantity.rb
  belongs_to :ingredient
  belongs_to :recipe
```

Add a link to the layout to get to the new scaffold routes for `Quantity`.

```
  # app/views/layouts/application.html.erb
  <li>
    <%=link_to 'quantities', quantities_path %>
  </li>
```

Change the form for `Quantity` to use a select for its ingredient and recipe.

```
  # app/views/quantities/_form.html.erb
  <%= f.collection_select(:ingredient_id, Ingredient.all, :id, :name) %>


  <%= f.collection_select(:recipe_id, Recipe.all, :id, :name) %>
```

And in the quantity index and show pages, use the names for the associated objects (rather than the ids)

```
  # app/views/quantities/index.html.erb
  <td><%= quantity.ingredient.try(:name) %></td>
  <td><%= quantity.recipe.try(:name) %></td>
```

```
  # app/views/quantities/show.html.erb
  <%= @quantity.ingredient.try(:name) %>


  <%= @quantity.recipe.try(:name) %>
```

If we migrate and run can we create and display `Quantity` objects happily?

And what if we view the recipe now? It breaks, because we removed the `has_and_belongs_to_many :ingredients`, and we didn't replace it with anything else.

So lets add a new type of association; and tell Rails that there is an association between recipes and ingredients *through* the quantities.

```
  # app/models/recipe.rb
  has_many :quantities
  has_many :ingredients, through: :quantities
```

```
  # app/models/ingredient.rb
  has_many :quantities
  has_many :recipes, through: :quantities
```

Notice that the `through` association *has* to be defined after the source association is defined (otherwise Rails won't know what you're talking about).

That should be enough to fix the show pages for recipes and ingredients, but the forms currently don't set the quantity, so best to remove them for now.

Remove the `f.collection_check_boxes` code from the recipes and ingredients forms.

Lastly, in the show page for recipes, alter the iterator to loop through associated quantities and show the quantity too.

```
  # app/views/recipes/show.rb
  <% @recipe.quantities.each do |quantity| %>
    <%= quantity.amount %>
    <%= quantity.recipe.try(:name) %><br>
  <% end %>
```

Lastly, there's a spurious join table still in our DB... we need to delete that.

```
  # terminal
  rails g migration DropIngredientsRecipes
```

```
  # db/migrate/TIMESTAMP_drop_ingredients_recipes.rb
  class DropIngredientsRecipes < ActiveRecord::Migration
    def up
      drop_table :ingredients_recipes
    end

    def down
      create_join_table :ingredients, :recipes
    end
  end
```

It's certainly *possible* to assign ingredients to a recipe on its form, along with the quantity; but it's a bit more involved, and we need to get on... we have working functionality for now.


