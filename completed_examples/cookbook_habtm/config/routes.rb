Rails.application.routes.draw do
  root to: 'recipes#index'

  resources :recipes
  resources :ingredients
  resources :categories
end
