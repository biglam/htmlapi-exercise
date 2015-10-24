require 'pry-byebug'
require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pg'

require_relative 'models/db_base'
require_relative 'models/category'
require_relative 'models/recipe'
require_relative 'models/ingredient'

require_relative 'controllers/categories_controller'
require_relative 'controllers/recipes_controller'
require_relative 'controllers/ingredients_controller'

get '/' do
  erb :home
end

