Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:show, :index, :update] do
    member do
        get :following, :followers
      end
        get :search, on: :collection
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get 'tweets/category/:id' => 'tweets#category', as: 'tweet_category'
  resources :notifications, only: :index
  resources :relationships, only: [:create, :destroy]

  resources :tweets do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    resources :categories, only: [:index, :create, :edit, :update]
    get :search, on: :collection
    collection do
      get 'confirm'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "homes#index"
  get 'contacts/new' => 'contacts#new', as: 'contact'
  post 'contacts/new', to: 'contacts#create'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'

end
