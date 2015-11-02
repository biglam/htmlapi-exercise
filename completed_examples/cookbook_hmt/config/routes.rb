Rails.application.routes.draw do
  resources :quantities
  root to: 'recipes#index'

  resources :recipes
  resources :ingredients
  resources :categories
end
