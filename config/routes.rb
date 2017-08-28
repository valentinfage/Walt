Rails.application.routes.draw do
  devise_for :users, controllers: {
        # registrations: 'users/registrations'
      }

  # get "/users/edit", to: "users#edit"
  # patch "/users/update", to: "users#update"

  resources :reminders, only: [:new, :create, :edit, :destroy, :index, :update]
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
