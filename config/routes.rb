Rails.application.routes.draw do
  # root to: "site#index"

  get "/" => "session#new"
  post "/" => "session#create"
  # post "/users/:user_id/events/new" => "events#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"
  get "/authorized" => "session#authorized"

  get "/signup" => "users#new"
  post "/users/new" => "users#create"

  get "/user_records" => "gifter_templates#user_records"
  get "/event_records" => "gifter_templates#event_records"
  get "/profile_records" => "gifter_templates#profile_records"
  get "/user_to_events_records" => "gifter_templates#user_to_events_records"

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
