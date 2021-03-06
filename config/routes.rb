Rails.application.routes.draw do
  get 'errors/internal_server_error'
  get 'errors/not_found'
  get 'errors/unprocessable_entity'
  get 'pages/denied'
  resources :testes
  resources :clients do
    collection do
      get "confirm"
      get "finish_confirm"
    end
  end
  resources :running_jobs do
    member do
      get "is_complete"
    end
  end
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
      get "paid"
      get 'refund'
    end
  end
  resources :transaction_accounts
  resources :signatures do
    collection do
      post "create_sign"
    end
  end
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
      get "update_hour_cost"
    end
  end

  resources :square_api do
    collection do
      get "oauth"
      get "callback"
      get "nonce"
      get "nonce_success"
      post "add_card"
      post "process_payment"
      get "checkout"
      get 'index_cards'
      delete 'destroy_card'
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
  resources :measurement_areas do
    member do
      post 'add_images'
      delete 'remove_image'
      delete 'remove_all_images'
    end
  end
  resources :estimates do
    member do
      get "schedule"
      get "products"
      get "send_mail"
      get "send_grid_mail"
      get "estimate_signature"
      post "create_products_estimates"
      get "new_note"
      post "new_document"
      get "create_order"
      get "clone"
      put "tax_calculation"
      put "taxpayer"
      get "cancel"
      get "reactivate"
      post "apply_discount"
      get 'decline_estimate'
      patch 'autosave_areas'
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
      get "new_labor_cost"
      get "new_cost"
      get "order_photos"
      get "create_doc_for_signature"
      get "deliver_products"
      post "deliver_products_sign"
      get "deliver_products_sign"
      get "send_sign_mail"
      get "finish"
      get "finish_order_signature"

      get "finish_order"
      get "change_order"
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
      put "change_transaction_value"
      put "change_payment_status_to_pendent"
      get "costs"
      get "cancel"
      get "reactivate"
    end
    collection do
      delete ":order_id/schedule/:schedule_id/delete", to: "orders#delete_schedule"
      get "doc_signature_mail"
      get "doc_signature"
    end
  end
  resources :leads

  resources :menus
  resources :profiles
  resources :products do
    collection do
      post 'new_delivery'
    end
    member do
      get 'sticker'
      get 'quick_estimate'
    end
  end
  resources :document_files
  resources :calculation_formulas do
    collection do
      get "taxes"
      post "lxw/product/:product_id" => "calculation_formulas#calculate_product_qty_lw"
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
      get "add_card"
      get "mail_card"
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

  resources :settings do
    collection do
      get "email"
      get "company_logo"
      get "cached_logo"
      get "company_banner"
      get "estimate"
      get "transactions" => 'settings#transactions'

      get "show_site"
      get "new_site"
      get "create_site"
      get "edit_site"
      #get "unpublish_site"
      post "update_site"
      #delete "delete_site"

      post "atualiza_settings"
      post "atualiza_transactions"
    end
  end

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

  get 'finances/dashboard' => 'finances#dashboard', as: :finance_dashboard
  get 'finances/dashboard_orders' => 'finances#dashboard_orders', as: :finance_dashboard_orders

  get 'initialization' => 'bot#initialization', as: :initialization_bot
  post 'initialization' => 'bot#create_initialization', as: :create_initialization
  #Api
  get 'api/woffice_pay_code'
  get 'api/orders' => "orders#index", as: :api_orders
  get 'api/orders/:id' => "orders#show", as: :api_order
  get 'api/orders/:id/payments' => "orders#pendent_payments", as: :api_order_payments
  post 'api/payment/:id/pay' => "api#order_paid", as: :api_payment_pay

  get 'welcome' => 'welcome#index'

  # custom error routes
  match '/404' => 'errors#not_found', :via => :all
  match '/422' => 'errors#unprocessable_entity', :via => :all
  #match '/500' => 'errors#internal_server_error', :via => :all

  root "users#home"
end
