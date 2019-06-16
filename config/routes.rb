Rails.application.routes.draw do
  # Resources
  resources :companies do
    member do
      get :destroy_modal
    end
  end

  resources :users do
    member do
      get :update_password
      patch :update_password_commit
    end
  end

  resources :dock_requests

  # Other routes
  root 'static_pages#home'
  get 'static_pages/home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/become_user', to: 'sessions#become_user'


end
