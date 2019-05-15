Rails.application.routes.draw do
  # Resources
  resources :companies
  
  root 'static_pages#home'
  get 'static_pages/home'


end
