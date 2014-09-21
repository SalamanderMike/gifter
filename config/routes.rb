Rails.application.routes.draw do
  get "/" => "session#new"
  post "/" => "session#create"
  get "/login" => "session#new"
  # post "/login" => "session#create"
  get "/logout" => "session#destroy"

  root to: 'session#index'

  resources :session
  resources :users
end
