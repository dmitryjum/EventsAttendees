# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1 do
    resources :events, only: %i[index show create update destroy] do
      member do
        post :rsvp
      end
    end

    resources :attendees, only: %i[show create update destroy]
  end
end
