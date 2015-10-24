class Recipe < DBBase

  attributes name: :string,
              description: :text,
              category_id: :integer

  def category
    @category ||= Category.find(category_id)
  end

  def ingredients
    return @ingredients if @ingredients
    results = run_sql("select * from ingredients where recipe_id = #{id}")
    @ingredients = results.map { |result| Ingredient.new(result) }
  end


end

