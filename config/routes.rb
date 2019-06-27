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

  resources :dock_requests do
    member do
      get :dock_assignment_edit
      patch :dock_assignment_update
    end
  end

  resources :dock_groups
  resources :docks

  # Other routes
  root 'static_pages#home'
  get 'static_pages/home'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/become_user', to: 'sessions#become_user'


end
