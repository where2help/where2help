Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  resources :users

  namespace :api do
    namespace :v1 do
      jsonapi_resources :needs
      jsonapi_resources :volunteerings
      get 'org/needs' => 'needs#ngo_index'
      post 'sessions/create' => 'sessions#create'
      delete 'sessions/destroy' => 'sessions#destroy'
    end
  end

  resources :needs
  get :needs_feed, to: 'needs#feed'

  resources :volunteerings, only: [:create, :destroy]

  get  'pages/calendar' => 'pages#calendar'
end
