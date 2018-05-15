Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  root    'static_pages#home'
  get     '/post',    to: "static_pages#post"
  get     '/help',    to: "static_pages#help"
  get     '/signup',  to: "users#new"
  post    '/signup',  to: "users#create"
  get     '/login',   to: "sessions#new"
  post    '/login',   to: "sessions#create"
  delete  '/logout',  to: "sessions#destroy"
  get     '/status',  to: "users#status"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :favorites,           only: [:create, :destroy]
end
