Rails.application.routes.draw do
  # root to: "site#index"

  get "/" => "session#new"
  post "/" => "session#create"
  # post "/users/:user_id/events/new" => "events#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"

  root to: 'session#new'
  resources :site
  resources :session
  resources :gifter_templates
  resources :users do
    resources :events
    resources :profile
  end
  # match "*path", to: "site#index", via: "get"
end
