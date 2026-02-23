Rails.application.routes.draw do
  get "subjects/show"
  get "exams/index"
  get "exams/show"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users, only: [:show]

  resources :exams, only: [:index, :show] do
    resources :subjects, only: [:show]
  end

  resources :subjects, only: [:show] do
    resources :topics, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  resources :topics, only: [:index] do
    collection do
      get :active_recall_index
      get :search
      post :import
    end
    resources :study_logs, only: [:create]

    resource :study_log, only: [] do
      match :create_or_update, via: [:post, :patch]
    end
  end

  authenticated :user do
    root "users#show", as: :user_root
  end

  root "exams#index"
end
