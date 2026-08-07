Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      devise_for :users, skip: :all, controllers: {
        sessions: "api/v1/users/sessions",
        passwords: "api/v1/users/passwords"
      }

      devise_scope :"api_v1_user" do
        post   "/login",          to: "users/sessions#create"
        delete "/logout",         to: "users/sessions#destroy"
        post   "/users/password", to: "users/passwords#create"
        put    "/users/password", to: "users/passwords#update"
      end

      resources :users, only: [:index, :show, :create, :update, :destroy]
      put "/users/:id/change_password", to: "users#change_password"
      resources :categorias
      resources :livros
    end
  end
end
