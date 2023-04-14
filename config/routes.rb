Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "uploads#index"

  resources :uploads, only: [:create, :update] do
    resources :payments, only: [:index]
  end
end
