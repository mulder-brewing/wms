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

  resources :access_policies

  resources :dock_requests do
    member do
      get :dock_assignment_edit
      patch :dock_assignment_update
      patch :unassign_dock
      patch :check_out
      patch :void
    end
  end
  get '/dock_requests_history', to: 'dock_requests#history'

  resources :dock_groups
  resources :docks

  # Other routes
  root 'static_pages#home'
  get 'static_pages/home'
  get 'dock_request_audit_histories/index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/become_user', to: 'sessions#become_user'


end
