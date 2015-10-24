class Category < DBBase

  attributes name: :string

  def recipes
    return @recipes if @recipes
    results = run_sql("select * from recipes where category_id = #{id}")
    @recipes = results.map { |result| Recipe.new(result) }
  end


end

