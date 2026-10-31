Rails.application.routes.draw do
  get "discover_salons/index"
  get "discover_salons/show"
  namespace :admin do
    get "dashboard/index"
  end
  namespace :salon_owner do
    get "dashboard/index"
  end
  namespace :customer do
    get "dashboard/index"
  end
  # devise_for :users
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  get "customer/dashboard", to: "customer/dashboard#index", as: :customer_dashboard
  get "salon_owner/dashboard", to: "salon_owner/dashboard#index", as: :salon_owner_dashboard
  get "admin/dashboard", to: "admin/dashboard#index", as: :admin_dashboard

  resources :salons

  get "search", to: "discover_salons#index", as: :search_salons
  get "discover/salons/:id", to: "discover_salons#show", as: :discover_salon

  resources :salons do
    resources :services, except: [ :show ]
    resources :appointments, only: [ :new, :create ]
  end

  resources :appointments, only: [ :index, :show ] do
    member do
      patch :cancel
    end
  end

  namespace :salon_owner do
    resources :appointments, only: [ :index, :show ] do
      member do
        patch :confirm
        patch :cancel
        patch :update_attendance
        patch :record_payment
      end
    end
  end
end
