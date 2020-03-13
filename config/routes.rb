Rails.application.routes.draw do
  # Resources

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

  resources :companies, except: :show do
    member do
      get :destroy_modal
    end
  end

  resources :dock_groups, except: [:show, :destroy]
  resources :docks, except: [:show, :destroy]

  namespace :dock_queue do
    resources :dock_requests, except: [:destroy]
    resources :history_dock_requests, only: [:index]
    resources :dock_assignments, only: [:edit, :update]
    resources :dock_unassignments, only: [:update]
    resources :void_dock_requests, only: [:edit, :update]
    resources :check_out_dock_requests, only: [:edit, :update]
    resources :dock_request_audit_histories, only: [:index]
  end

  resources :locations, except: [:show, :destroy]

  namespace :order do
    resources :order_groups, except: [:show, :destroy]
  end

  resources :shipper_profiles, except: [:show, :destroy]

  # Other routes
  root 'static_pages#home'
  get 'static_pages/home'
  get '/login', to: 'auth/sessions#new'
  post '/login', to: 'auth/sessions#create'
  delete '/logout', to: 'auth/sessions#destroy'
  get '/become_user', to: 'auth/sessions#become_user'


end
