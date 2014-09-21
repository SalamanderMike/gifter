Rails.application.routes.draw do
  get "/" => "session#new"
  post "/" => "session#create"
  get "/login" => "session#new"
  get "/logout" => "session#destroy"

  root to: 'session#new'

  resources :session
  resources :users
end
