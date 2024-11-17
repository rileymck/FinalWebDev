Rails.application.routes.draw do
  get 'users/new'
  get "theme", to: "theme#update", as: "set_theme"
  devise_for :users, controllers: {
    passwords: 'users/passwords'
  }

  resources :users, only: [:new, :create]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "users#new"

  
end
