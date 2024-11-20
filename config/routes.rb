Rails.application.routes.draw do
  #resources :chats
  get 'users/new'
  get "theme", to: "theme#update", as: "set_theme"
  devise_for :users, controllers: {
    passwords: 'users/passwords'
  }

  resources :chats, only: [:index, :create, :destroy, :edit, :update, :show]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #root "users#new"
  #root "chats#index"

  

  authenticated :user do
    root to: "chats#index", as: :authenticated_root # Root for logged-in users
  end

  devise_scope :user do
    unauthenticated do
      root to: "devise/registrations#new", as: :unauthenticated_root # Root for non-logged-in users
    end
  end
end
