get '/recipes' do
  @recipes = Recipe.all
  erb :'recipes/index'
end

get '/recipes/new' do
  @recipe = Recipe.new
  @categories = Category.all
  erb :'recipes/new'
end

get '/recipes/:id' do
  @recipe = Recipe.find(params[:id])
  erb :'recipes/show'
end

post '/recipes' do
  @recipe = Recipe.new(params[:recipe])
  @recipe.save
  redirect to("/recipes/#{@recipe.id}")
end

get '/recipes/:id/edit' do
  @recipe = Recipe.find(params[:id])
  @categories = Category.all
  erb :'recipes/edit'
end

post '/recipes/:id' do
  @recipe = Recipe.find(params[:id].to_i)
  @recipe.update_attributes(params[:recipe])
  redirect to("/recipes/#{@recipe.id}")
end

post '/recipes/:id/delete' do
  Recipe.find(params[:id]).destroy
  redirect to('/recipes')
end

