Rails.application.routes.draw do

  resources :labor_costs do
    member do
      get "new_note"
      post "new_document"
      get "change_status"
    end
  end
  resources :product_purchases do
    member do
      get "new_note"
      post "new_document"
      get "change_status"
    end
  end
  resources :purchases
  resources :documents do
    member do
      get "add_custom"
    end
    collection do
      post "save_data"
      get "preview"
      get "send_customs"
      post "send_mail"
    end
  end
  resources :transactions do
    member do
      get "send_square"
      get "send_square_again"
    end
  end
  resources :transaction_accounts
  resources :signatures
  resources :transaction_categories
  resources :product_estimates
  resources :measurement_proposals
  #mount Plutus::Engine => "/plutus", :as => "plutus"
  #

  devise_for :users
  resources :users do
    collection do
      get "home"
    end
  end

  resources :schedules do
    collection do
      get "redirect_schedule"
      get "new_note"
      post "new_document"
      get "load_notes"
      get "delete_schedule"
    end
  end

  resources :square_api do
    collection do
      get "callback"
      get "teste_pagamento"
      post "process_payment"
      get "checkout"
    end
  end

  resources :accounts do
    collection do
      get "new_entry"
      post "create_entry"
      get "entries"
      get "balance"
    end
  end

  resources :measurements
  resources :measurement_areas
  resources :estimates do
    member do
      get "schedule"
      get "products"
      get "send_mail"
      get "estimate_signature"
      post "create_products_estimates"
    end
    collection do
      get ":id/measurements", to: "measurement_areas#measurements", as: :measurement_view
      post ":id/measurements", to: "measurement_areas#create_measurements", as: :create_measurements
      get "step_one/:lead_id", to: "estimates#step_one", as: :step_one
      post "create_step_one/:lead_id", to: "estimates#create_step_one", as: :create_step_one
      post ":estimate_id/schedule/new", to: "estimates#create_schedule"
      delete ":estimate_id/schedule/:schedule_id/delete", to: "estimates#delete_schedule"
      get ":estimate_id/view", to: "estimates#view_estimate", as: :view
    end
  end
  resources :orders do
    member do
      get "new_note"
      post "new_document"
      get "new_contact"
      
      get "schedule"
      post "create_schedule"
      
      get "payments"
      
      get "product_purchase"
      get "invoice"
      get "invoice_add_payment"
      get "view_invoice_customer"
      get "send_invoice_mail"
      get "costs"
    end
    collection do
      delete ":order_id/schedule/:schedule_id/delete", to: "orders#delete_schedule"

    end
  end
  resources :leads

  resources :menus
  resources :profiles
  resources :products
  resources :document_files
  resources :calculation_formulas do
    collection do
      get "lxw/product/:product_id" => "calculation_formulas#calculate_product_qty_lw"
    end
  end
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
    collection do
      get "search_customers"
      get "search_by_phone/:phone", to: "customers#search_by_phone"
      get "search_by_email/:email", to: "customers#search_by_email"
    end

  end
  resources :workers do
    member do
      get "new_note"
      post "new_document"
      get "new_contact"
      get "update_contact"
    end
    collection do
      get "load_notes"
    end
  end

  resources :settings

  #BPM routes
  get 'bpm/start/:process' => "bpm#start_process", as: :bpm_start_process
  get 'bpm/tasks' => "bpm#tasks", as: :bpm_tasks
  get 'bpm/assignee_tasks' => "bpm#assignee_tasks", as: :bpm_assignee_tasks
  get 'bpm/assignee_group_tasks' => "bpm#assignee_group_tasks", as: :bpm_assignee_group_tasks
  get 'bpm/task_information/:id' => 'bpm#task_information', as: :bpm_task_information
  get 'bpm/assignee/:id/:instance' => 'bpm#assignee', as: :bpm_assignee
  get 'bpm/task/:id' => 'bpm#task', as: :bpm_task
  get 'bpm/task/:id/complete' => "bpm#complete_task", as: :bpm_complete_task
  get 'bpm/process/:id' => 'bpm#instance', as: :process
  get 'bpm/process_activity/:id' => "bpm#process_activity", as: :bpm_process_activity
  get 'bpm/comments/:id' => "bpm#comments", as: :bpm_comments
  get 'bpm/diagram/:id' => "bpm#diagram", as: :bpm_diagram
  get 'bpm/diagram/:key/:id' => "bpm#diagram", as: :bpm_diagram_with_key
  get 'bpm/callback/:id' => "bpm#callback", as: :bpm_callback
  post 'bpm/start' => "bpm#create_instance", as: :create_instance
  post 'bpm/complete_task' => "bpm#fix_task", as: :bpm_fix_task


  #Bpmn Editor
  post 'bpmn_editor/deploy' => "bpmn_editor#deploy", as: :bpmn_editor_deploy
  get 'bpmn_editor/' => "bpmn_editor#list", as: :bpmn_editor_list
  get 'bpmn_editor/process/:id' => "bpmn_editor#editor", as: :bpmn_editor
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'document_prototype/create'
  get 'document_prototype/deliver'
  get 'document_prototype/sign'

  root "users#home"
end
