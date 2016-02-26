Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks' }
  devise_for :ngos, controllers: {
    confirmations: 'ngos/confirmations',
    passwords: 'ngos/passwords',
    registrations: 'ngos/registrations',
    sessions: 'ngos/sessions',
    unlocks: 'ngos/unlocks' }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users do
        collection do
          post 'login'
          delete 'destroy'
          get 'logout'
          post 'change_password'
          post 'send_reset'
        end
      end

      devise_scope :user do
        post "registrations"=> "registrations#create"
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
