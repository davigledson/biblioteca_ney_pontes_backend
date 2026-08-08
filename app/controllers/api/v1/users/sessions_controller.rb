module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        skip_before_action :require_no_authentication, only: [:create], raise: false
        skip_before_action :verify_signed_out_user, raise: false

        respond_to :json

        def create
          user = User.find_by(email: params[:email])

          if user&.valid_password?(params[:password])
            token = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil).first

            render json: {
              message: "Login realizado com sucesso",
              user: {
                id: user.id,
                nome: user.nome,
                email: user.email,
                role: user.role,
                first_login: user.first_login
              },
              token: token
            }, status: :ok
          else
            render json: { error: "E-mail ou senha inválidos" }, status: :unauthorized
          end
        end

        def destroy
          if current_api_v1_user
            sign_out(resource_name)
          end

          render json: { message: "Logout realizado com sucesso" }, status: :ok
        end
      end
    end
  end
end
