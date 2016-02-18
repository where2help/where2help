Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  devise_for :ngos, controllers: { sessions: "ngos/sessions" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
