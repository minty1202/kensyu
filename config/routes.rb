Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  namespace :users do
    resource :mypage, only: :show
    resources :todos, only:[:new, :create, :edit, :update, :destroy] do
      resources :comments, only: [:create]
    end
  end


  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_scope :admin do
    get '/admins/sign_out' => 'devise/sessions#destroy'
  end
  namespace :admins do
    resources :dashbord , only: [:show, :destroy]
  end

  root 'general#index'
end
