Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    post 'register', to: 'authentication#register'
    post 'login', to: 'authentication#login'
    get 'authenticated', to: 'authentication#authenticated'
    get 'admin_authenticated', to: 'authentication#admin_authenticated'

    resources :collections, only: [:index, :create, :destroy, :update]
    resources :items, only: [:index, :create]
    resources :categories, only: [:index]
  end

end
