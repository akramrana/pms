Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  get 'issues/:id/board_list', :to => 'issues#board_list'
  get 'issues/:id/quick_create', :to => 'issues#quick_create'
  get 'boards/:id/quick_create', :to => 'boards#quick_create'
  post 'issues/:id/add_comment', :to => 'issues#add_comment'
  get 'issue_checklists/:id/quick_create', :to => 'issue_checklists#quick_create'
  get 'issue_images/:id/quick_create', :to => 'issue_images#quick_create'

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


  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
