Rails.application.routes.draw do

  devise_for :users
  resources :users do
    post :admin_confirm, on: :member
  end
  devise_scope :user do
    namespace :ngos do
      get :sign_up, to: 'registrations#new'
      post :sign_up, to: 'registrations#create'
    end
  end

  namespace :api do
    namespace :calendar do
      jsonapi_resources :needs
      get 'org/needs' => 'needs#ngo_index'
    end

    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
      jsonapi_resources :needs
      jsonapi_resources :volunteerings
    end
  end

  resources :needs
  get :needs_feed, to: 'needs#feed'

  resources :volunteerings, only: [:create, :destroy]

  get 'pages/calendar' => 'pages#calendar'
  get 'pages/home' => 'pages#home'
  root 'pages#home'
end
