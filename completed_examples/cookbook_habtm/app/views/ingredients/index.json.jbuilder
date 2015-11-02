json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :name, :image
  json.url ingredient_url(ingredient, format: :json)
end
