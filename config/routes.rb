Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  namespace :users do
    resource :mypage, only: :show do
      resources :tags, only: :show
      get '/status_todo', to: 'statuses#find_todo'
      get '/status_done', to: 'statuses#find_done'
      get '/status_expired', to: 'statuses#find_expired'
      resources :statuses, only: [:show]
    end
    resources :todos, only:[:new, :create, :edit, :update, :destroy] do
      resources :comments, only: [:create]
    end
    get '/search', to: 'searches#search'
  end


  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }

  namespace :admins do
    resource :dashbord , only: :show
    resources :users, only: [:index, :destroy]
  end

  root 'general#index'
end
