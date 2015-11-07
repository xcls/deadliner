Rails.application.routes.draw do
  resources :projects, only: [:index, :show]

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root 'home#index'

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
end