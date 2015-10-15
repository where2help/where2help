Rails.application.routes.draw do


  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  resources :users

  namespace :api do
    namespace :calendar do
      jsonapi_resources :needs, controller: "calendar_needs_controller"      
    end

    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

      jsonapi_resources :needs
      jsonapi_resources :volunteerings
      get 'org/needs' => 'needs#ngo_index'
    end
  end

  resources :needs
  get :needs_feed, to: 'needs#feed'

  resources :volunteerings, only: [:create, :destroy]

  get  'pages/calendar' => 'pages#calendar'
end
