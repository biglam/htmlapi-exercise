Category.delete_all
Ingredient.delete_all
Recipe.delete_all
ActiveRecord::Base.connection.exec_query("DELETE FROM ingredients_recipes")

c1 = Category.create!(name: 'starters')
c2 = Category.create!(name: 'dessert')
c3 = Category.create!(name: 'mains')

i1 = Ingredient.create!(name: 'Eggs')
i2 = Ingredient.create!(name: 'Salt')
i3 = Ingredient.create!(name: 'Flour')
i4 = Ingredient.create!(name: 'Pepper')
i5 = Ingredient.create!(name: 'Onion')
i6 = Ingredient.create!(name: 'Cheese')

Recipe.create!(name: 'Scrambled eggs', ingredient_ids: [i1.id, i2.id], category_id: c2.id)
Recipe.create!(name: 'Pancakes', ingredient_ids: [i2.id, i1.id, i3.id], category_id: c1.id)
Recipe.create!(name: 'Cheesy peppered onions', ingredient_ids: [i6.id, i4.id, i5.id], category_id: c2.id)

