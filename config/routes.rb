Rails.application.routes.draw do
  root to: 'photos#index'
  resources :photos, only: [:index, :new, :create] do
    collection do
      post :tweet
    end
  end

  # login
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # oauth
  get '/oauth/callback' => 'oauth#callback'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

end
