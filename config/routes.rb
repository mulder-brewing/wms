Rails.application.routes.draw do
  # Resources
  resources :companies do
    member do
      get :destroy_modal
    end
  end
  resources :users

  root 'static_pages#home'
  get 'static_pages/home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


end
