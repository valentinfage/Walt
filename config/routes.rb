Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  resources :reminders, only: [:new, :create, :edit, :destroy, :index, :update]
  root to: 'pages#home'

  resources :emails, only: [:new, :create, :edit, :destroy, :index, :update]
  root to: 'pages#home'

    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        resources :reminders, only: [:new, :create, :edit, :destroy, :index, :update] do
          post "send", to: "reminders#sendsms"
        resources :emails, only: [:new, :create, :edit, :destroy, :index, :update] do
          post "send", to: "emails#sendsms"
        end
      end
    end
  end
end
