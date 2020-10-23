Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :users
  resources :user_types
  resources :issue_types
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
