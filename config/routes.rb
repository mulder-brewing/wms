Rails.application.routes.draw do
  # Resources
  resources :companies do
    member do
      get :destroy_modal
    end
  end

  namespace :auth do
    resources :users, only: [:edit, :update, :index]
    resources :users, only: :new, to: 'user_new_create_forms#new'
    resources :user_new_create_forms, only: [:new, :create]
    resources :password_resets, only: [:new, :create]
    resources :password_update_forms, only: [:edit, :update]
  end

  resources :access_policies do
    collection do
      get :company
    end
  end

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
  get '/login', to: 'auth/sessions#new'
  post '/login', to: 'auth/sessions#create'
  delete '/logout', to: 'auth/sessions#destroy'
  get '/become_user', to: 'auth/sessions#become_user'


end
