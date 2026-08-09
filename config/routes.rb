Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      devise_for :users, skip: :all, controllers: {
        sessions: "api/v1/users/sessions",
        passwords: "api/v1/users/passwords"
      }

      devise_scope :"api_v1_user" do
        post   "/login",          to: "users/sessions#create", defaults: { format: :json }
        delete "/logout",         to: "users/sessions#destroy", defaults: { format: :json }
        post   "/users/password", to: "users/passwords#create", defaults: { format: :json }
        put    "/users/password", to: "users/passwords#update", defaults: { format: :json }
      end

      post "/registro", to: "registros#create"

      resource :perfil, only: [:show, :update], controller: "perfis"

      resources :users, only: [:index, :show, :create, :update, :destroy]
      put "/users/:id/change_password", to: "users#change_password"

      resources :categorias
      resources :livros do
        member do
          get :historico
          get :capa
        end
      end
      resources :cidadaos, controller: "usuario_bibliotecas", as: "usuario_bibliotecas" do
        member do
          get :carteirinha
          post :enviar_senha_emprestimo
        end
      end

      resources :emprestimos, only: [:index, :show, :create] do
        member do
          put :devolver
          put :renovar
          put "multa/pagar", to: "emprestimos#pagar_multa", as: :pagar_multa
        end
        collection do
          get :atrasados
          get :historico
        end
      end

      get "relatorios/emprestimos", to: "relatorios#emprestimos"
      get "relatorios/multas", to: "relatorios#multas"
    end
  end

  get "/api/v1/users/password/edit", to: "api/v1/users/passwords#edit", as: :edit_api_v1_user_password
end