class Ingredient < DBBase

  attributes name: :string, quantity: :decimal, unit: :string, recipe_id: :integer

  def recipe
    @recipe ||= Recipe.find(recipe_id)
  end

end

