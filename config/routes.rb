Rails.application.routes.draw do

  devise_for :users
  resource :user, only: [:show] do
    get :appointments, to: 'volunteers/needs#index'
  end
  namespace :admin do
    resources :users
  end
  # resources :users do
  #   post :admin_confirm, on: :member
  # end

  namespace :volunteers do
    #resources :needs, only: :show
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
      jsonapi_resources :users
    end
  end

  resources :needs, only: [:index, :show]
  # do
  #   get :list, on: :collection
  # end

  resources :volunteerings, only: [:create, :destroy]

  get 'pages/calendar' => 'pages#calendar'
  get 'pages/home' => 'pages#home'
  root 'pages#home'
end
