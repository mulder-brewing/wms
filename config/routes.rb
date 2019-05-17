Rails.application.routes.draw do
  # Resources
  resources :companies do
    member do
      get :destroy_modal
    end
  end

  root 'static_pages#home'
  get 'static_pages/home'


end
