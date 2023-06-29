Rails.application.routes.draw do
  get 'games/index'
  devise_for :users
  root to: "pages#home"

  resources :events do
    resources :bookings, only: %i[new create]
    resources :bookmarks, only: %i[new create]
    resources :reviews, only: %i[new create edit update]
  end

  resources :bookings, only: %i[index edit update destroy]
  # member do
  #   patch :accepted, to: ""
  #   patch :declined, to: ""
  # end

  resources :users, only: %i[show edit update]
  # get "profile", to: "pages#profile"
  # get "profile/:id", to: "pages#profileshow", as: :show_profile

  resources :bookmarks, only: %i[destroy]

  resources :chatrooms, only: %i[index show create] do
    resources :messages, only: :create
  end

  resources :games do
    post :save_game, on: :collection
    post :my_game, on: :collection
  end

  get '/games/show', to: 'games#show', as: 'show_games'
  get '/games', to: 'games#index'
end
