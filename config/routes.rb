Rails.application.routes.draw do
  devise_for :user, only: []

  namespace :v1, defaults: { format: :json } do
    resource :login, only: [:create], controller: :sessions
    resources :stories, except: [:new, :edit]
  end
end
