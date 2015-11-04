Category.delete_all
Ingredient.delete_all
Recipe.delete_all
Quantity.delete_all

c1 = Category.create!(name: 'starters')
c2 = Category.create!(name: 'dessert')
c3 = Category.create!(name: 'mains')

i1 = Ingredient.create!(name: 'Eggs')
i2 = Ingredient.create!(name: 'Salt')
i3 = Ingredient.create!(name: 'Flour')
i4 = Ingredient.create!(name: 'Pepper')
i5 = Ingredient.create!(name: 'Onion')
i6 = Ingredient.create!(name: 'Cheese')

r1 = Recipe.create!(name: 'Scrambled eggs', category_id: c2.id)
r2 = Recipe.create!(name: 'Pancakes', category_id: c1.id)
r3 = Recipe.create!(name: 'Cheesy peppered onions', category_id: c2.id)


Quantity.create!(recipe: r1, ingredient: i1, quantity: '2 large')
Quantity.create!(recipe: r1, ingredient: i2, quantity: '1 pinch')

Quantity.create!(recipe: r2, ingredient: i1, quantity: '1 large')
Quantity.create!(recipe: r2, ingredient: i3, quantity: '200 grams')

Quantity.create!(recipe: r3, ingredient: i4, quantity: '2 pinches')
Quantity.create!(recipe: r3, ingredient: i5, quantity: 'half a large')
Quantity.create!(recipe: r3, ingredient: i6, quantity: '100 grams')



