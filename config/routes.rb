Rails.application.routes.draw do
  resources :projects, only: [:index, :show]
  resources :deadlines, only: [:show]
  resources :dashboards, only: [:new, :create, :update, :destroy]

  get '/dashboards/edit', to: 'dashboards#edit', as: :edit_dashboard
  get '/dashboards/:link_slug', to: 'dashboards#show', as: :show_dashboard

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root 'home#index'

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end
