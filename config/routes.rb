Rails.application.routes.draw do
  resources :customers
  resources :workers
  resources :settings

  #BPM routes
  get 'bpm/start/:process' => "bpm#start_process"
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
  post 'bpm/start' => "bpm#create_instance", as: :create_instance
  post 'bpm/complete_task' => "bpm#fix_task", as: :bpm_fix_task

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
