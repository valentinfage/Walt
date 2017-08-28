Rails.application.routes.draw do
  devise_for :users, controllers: {
        # registrations: 'users/registrations'
      }
  resources :reminders, only: [:new, :create, :edit, :destroy, :index, :update]
  root to: 'pages#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :reminders, only: [:new, :create, :edit, :destroy, :index, :update]
    end
  end
end
