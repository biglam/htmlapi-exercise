json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :category_id, :description, :instructions
  json.url recipe_url(recipe, format: :json)
end
