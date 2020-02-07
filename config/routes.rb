Rails.application.routes.draw do
  resources :contacts
  resources :notes
  resources :suppliers
  resources :product_categories
  resources :customers
  resources :workers
  resources :settings
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
