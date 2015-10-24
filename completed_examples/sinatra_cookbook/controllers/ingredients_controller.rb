get '/recipes/:recipe_id/ingredients/new' do
  @ingredient = Ingredient.new
  @recipe = Recipe.find(params[:recipe_id])
  erb :'ingredients/new'
end

post '/recipes/:recipe_id/ingredients' do
  @ingredient = Ingredient.new(params[:ingredient])
  @ingredient.recipe_id = params['recipe_id']
  @ingredient.save

  redirect to("/recipes/#{params['recipe_id']}")
end

get '/recipes/:recipe_id/ingredients/:id/edit' do
  @ingredient = Ingredient.find(params[:id])
  @recipe = Recipe.find(params[:recipe_id])
  erb :'ingredients/edit'
end

post '/recipes/:recipe_id/ingredients/:id' do
  @ingredient = Ingredient.find(params[:id].to_i)
  @ingredient.update_attributes(params[:ingredient])
  @ingredient.save
  redirect to("/recipes/#{params['recipe_id']}")
end

post '/recipes/:recipe_id/ingredients/:id/delete' do
  Ingredient.find(params[:id]).destroy
  redirect to("/recipes/#{params['recipe_id']}")
end

