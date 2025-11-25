Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "main" => "pages#main", as: :main
  resources :registers, only: [:create]
  resources :gembas, only: [:new, :create]
  resources :companies, only: [:new, :create]
  resources :profiles, only: [:new, :create]
  resources :schedules, only: [:new, :create, :index] do
    collection do
      get :by_date
    end
  end

# Import
get  "data_import",           to: "data_import#index"
post "data_import/users",     to: "data_import#users"
post "data_import/gembas",     to: "data_import#gembas"
# Export
get "data_export", to: "data_export#index"
get "data_export/example_export", to: "data_export#example_export", as: :example_export

  # Defines the root path route ("/")
  # root "posts#index"
end
