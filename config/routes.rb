Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :events do
    resources :bookings, only: %i[new create]
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

  ## routes for chatroom
end
