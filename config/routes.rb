Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :menus
  resources :profiles
  resources :products
  resources :document_files
  resources :calculation_formulas
  resources :contacts
  resources :notes
  resources :suppliers do
    member do
      get "new_note"
      post "new_document"
      get "new_contact"
    end
  end
  resources :product_categories
  resources :customers  do
    member do
      get "new_note"
      post "new_document"
      get "new_contact"
    end
  end
  resources :workers do
    member do
      get "new_note"
      post "new_document"
      get "new_contact"
    end
  end

  resources :settings
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
