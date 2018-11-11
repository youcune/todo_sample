Rails.application.routes.draw do
  root controller: :home, action: :index

  namespace :api, format: :json do
    resources :tasks, only: [:index, :create, :update]
  end
end
