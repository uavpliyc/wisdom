Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:show, :index, :update] do
    member do
        get :following, :followers
      end
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get 'tweets/category/:id' => 'tweets#category', as: 'tweet_category'

  resources :tweets do
    resource :favorites, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    resources :categories, only: [:index, :create, :edit, :update]
    collection do
      get 'confirm'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get 'tweets/search/:id' => 'tweets#search',as: 'tweet_search'
  root "homes#index"

end
