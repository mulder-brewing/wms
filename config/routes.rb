Rails.application.routes.draw do
  # Resources
  resources :companies, except: :show do
    member do
      get :destroy_modal
    end
  end

  namespace :auth do
    resources :users, except: [:show, :destroy]
    resources :password_resets, only: [:edit, :update]
    resources :password_updates, only: [:edit, :update]
  end

  resources :access_policies, except: [:show, :destroy] do
    collection do
      get :company
    end
  end

  resources :dock_groups, except: [:show, :destroy]
  resources :docks, except: [:show, :destroy]

  namespace :dock_queue do
    resources :dock_requests, except: [:destroy]
    resources :dock_assignments, only: [:edit, :update, :destroy]
    resources :void_dock_requests, only: [:edit, :update]
    resources :check_out_dock_requests, only: [:edit, :update]
  end

  get '/dock_requests_history', to: 'dock_requests#history'

  # Other routes
  root 'static_pages#home'
  get 'static_pages/home'
  get 'dock_request_audit_histories/index'
  get '/login', to: 'auth/sessions#new'
  post '/login', to: 'auth/sessions#create'
  delete '/logout', to: 'auth/sessions#destroy'
  get '/become_user', to: 'auth/sessions#become_user'


end
