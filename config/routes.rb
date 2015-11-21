Rails.application.routes.draw do

  devise_for :users
  resource :user, only: [:show] do
    get :appointments, to: 'volunteers/needs#index'
  end
  namespace :admin do
    resources :users do
      post :confirm, on: :member
    end
    resources :needs, except: [:show, :new, :create]
  end

  # only temporary
  resources :needs

  namespace :volunteers do
  end

  namespace :ngos do
    resources :needs do
      get :calendar, on: :collection
    end
  end

  devise_scope :user do
    namespace :ngos do
      get :sign_up, to: 'registrations#new'
      post :sign_up, to: 'registrations#create'
    end
  end

  resources :volunteerings, only: [:create, :destroy]

  get 'pages/home' => 'pages#home'
  root 'pages#home'

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
end
