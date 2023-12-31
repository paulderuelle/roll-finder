Rails.application.routes.draw do
  get 'games/index'
  devise_for :users
  root to: "pages#home"

  resources :events do
    resources :bookings, only: %i[new create]
    resources :bookmarks, only: %i[new create]
    resources :reviews, only: %i[new create edit update]
  end

  get "/github", to: "github#index"
  get "/github/callback", to: "github#callback"

  resources :bookings, only: %i[index edit update destroy]
  # member do
  #   patch :accepted, to: ""
  #   patch :declined, to: ""
  # end

  resources :users, only: %i[show edit update] do
    post '/chatrooms', to: 'chatrooms#create', as: 'chatroom'
  end

  resources :bookmarks, only: %i[destroy]

  resources :reviews, only: %i[index]

  resources :chatrooms, only: %i[index show] do
    resources :messages, only: :create
  end

  resources :games do
    post :save_game, on: :collection
    post :my_game, on: :collection
    # get "/event/new", to: "events#new", as: "new_event"
    # post "/events", to: "events#create", as: "events"
  end

  get '/games/show', to: 'games#show', as: 'show_games'
  get '/games', to: 'games#index'
  get 'games/search', to: 'games#search'
end
