Rails.application.routes.draw do
  # post "/users/:user_id/profile" => "profile#create", :as => :user_profile_bind

  get "/" => "session#new"
  post "/" => "session#create"
  # post "/users/:user_id/events/new" => "events#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"
  get "/authorized" => "session#authorized"

  get "/signup" => "users#new"
  post "/signup" => "users#create"

  get "/index_participants/:event_id" => "events#index_participants"
  get "/index_admin_events" => "events#index_admin_events"

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
