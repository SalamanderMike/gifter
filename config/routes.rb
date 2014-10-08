Rails.application.routes.draw do
  # root to: "site#index"
  # post "/users/:user_id/profile" => "profile#create", :as => :user_profile_bind

  get "/" => "session#new"
  post "/" => "session#create"
  # post "/users/:user_id/events/new" => "events#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"
  get "/authorized" => "session#authorized"

  get "/signup" => "users#new"
  post "/signup" => "users#create"


  # get "/user_records" => "gifter_templates#user_records"
  # post "/user_records" => "gifter_templates#user_update"

  # get "/event_records" => "gifter_templates#event_records"

  # get "/profile_records" => "gifter_templates#profile_records"
  # post "/profile_records" => "gifter_templates#profile_create"

  # get "/user_events_records" => "gifter_templates#user_events_records"

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
