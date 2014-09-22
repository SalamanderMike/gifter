Rails.application.routes.draw do
  get "/" => "session#new"
  post "/" => "session#create"
  post "/users/:user_id/events/new" => "events#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"

  root to: 'session#new'

  resources :session
  resources :users do
    resources :events
  end
end
