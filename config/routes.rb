Rails.application.routes.draw do
  resources :projects, only: [:index, :show] do
    collection do
      get "/github/:uid",
        constraints: { uid: /.*/ },
        format: false,
        to: "projects#show"
    end
  end

  resources :deadlines, only: [:show]
  resources :dashboards, only: [:new, :create, :update, :destroy]

  get '/dashboards/edit', to: 'dashboards#edit', as: :edit_dashboard
  get '/x/:slug', to: 'dashboards#show', as: :show_dashboard
  get '/x/:slug/deadlines/:id', to: 'dashboards#show_deadline', as: :show_deadline

  get '/dashboards/:slug/log_in', to: 'dashboards#login', as: :login_dashboard
  post '/dashboards/:slug/authenticate', to: 'dashboards#authenticate', as: :authenticate_dashboard

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root 'home#index'

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
