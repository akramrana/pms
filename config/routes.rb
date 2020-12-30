Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :users
  resources :user_types
  resources :issue_types
  resources :priority_types
  resources :project_types
  resources :projects
  resources :issues
  resources :boards

  get 'issues/:id/board_list', :to => 'issues#board_list'
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
