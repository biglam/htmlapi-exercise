json.array!(@quantities) do |quantity|
  json.extract! quantity, :id, :ingredient_id, :recipe_id, :quantity
  json.url quantity_url(quantity, format: :json)
end
