Rails.application.routes.draw do

  #mount Plutus::Engine => "/plutus", :as => "plutus"
  #

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
    end
    collection do
      get ":id/measurements", to: "measurement_areas#measurements", as: :measurement_view
      post ":id/measurements", to: "measurement_areas#create_measurements", as: :create_measurements
      get "step_one/:lead_id", to: "estimates#step_one", as: :step_one
      post "create_step_one/:lead_id", to: "estimates#create_step_one", as: :create_step_one
      post ":estimate_id/schedule/new", to: "estimates#create_schedule"
      delete ":estimate_id/schedule/:schedule_id/delete", to: "estimates#delete_schedule"
    end
  end
  resources :orders
  resources :leads
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
    collection do
      get "teste_pagamento"
      post "process_payment"
      get "checkout"
      get "search_by_phone/:phone", to: "customers#search_by_phone"
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
end
