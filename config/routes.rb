Rails.application.routes.draw do
  resources :notifications
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'welcome/index'
  root 'welcome#index'

  get 'issues/:id/board_list', :to => 'issues#board_list'
  get 'issues/:id/quick_create', :to => 'issues#quick_create'
  get 'boards/:id/quick_create', :to => 'boards#quick_create'
  post 'issues/:id/add_comment', :to => 'issues#add_comment'
  post 'issues/:id/move', :to => 'issues#move'
  post 'issues/:id/complete_checklist', :to => 'issues#complete_checklist'
  post 'issues/:id/change_status', :to => 'issues#change_status'
  post 'issues/:id/delete_checklist_item', :to => 'issues#delete_checklist_item'
  post 'issues/:id/delete_attachment', :to => 'issues#delete_attachment'
  post 'issues/:id/delete_comment', :to => 'issues#delete_comment'
  get 'issue_checklists/:id/quick_create', :to => 'issue_checklists#quick_create'
  get 'issue_images/:id/quick_create', :to => 'issue_images#quick_create'
  get 'user_projects/:id/quick_create', :to => 'user_projects#quick_create'
    post 'user_projects/:id/delete_user', :to => 'user_projects#delete_user'

  get '/sessions', to: 'sessions#new'
  get '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :user_types
  resources :issue_types
  resources :priority_types
  resources :project_types
  resources :projects
  resources :issues
  resources :boards
  resources :issue_checklists
  resources :issue_images
  resources :sessions, only: [:new, :create, :destroy]
  resources :user_projects


  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
