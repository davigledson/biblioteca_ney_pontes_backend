Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, skip: :all, controllers: {
    sessions: "users/sessions",
    passwords: "users/passwords"
  }

  devise_scope :user do
    post   "/login",          to: "users/sessions#create"
    delete "/logout",         to: "users/sessions#destroy"
    post   "/users/password", to: "users/passwords#create"
    put    "/users/password", to: "users/passwords#update"
  end

  resources :users, only: [:index, :show, :create, :update, :destroy]
  put "/users/:id/change_password", to: "users#change_password"
end
