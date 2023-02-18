Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :v1 do
    resources :events, only: [:index, :show, :create, :update, :destroy] do
      member do
        post :rsvp
      end
    end

    resources :attendees, only: [:show, :create, :update, :destroy]
  end
end
