module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy, :change_password]

      def index
        users = User.all.order(created_at: :desc)
        render json: users.as_json(only: [:id, :nome, :email, :first_login, :created_at])
      end

      def show
        render json: @user.as_json(only: [:id, :nome, :email, :first_login, :created_at])
      end

      def create
        temp_password = SecureRandom.hex(8)
        user = User.new(user_params.merge(password: temp_password, password_confirmation: temp_password))

        if user.save
          render json: {
            message: "Bibliotecário cadastrado com sucesso",
            user: {
              id: user.id,
              nome: user.nome,
              email: user.email,
              first_login: user.first_login
            },
            temporary_password: temp_password
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_update_params)
          render json: {
            message: "Bibliotecário atualizado com sucesso",
            user: { id: @user.id, nome: @user.nome, email: @user.email, first_login: @user.first_login }
          }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        render json: { message: "Bibliotecário removido com sucesso" }, status: :ok
      end

      def change_password
        if @user.update(password_params.merge(first_login: false))
          render json: { message: "Senha alterada com sucesso" }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
        render json: { error: "Bibliotecário não encontrado" }, status: :not_found unless @user
      end

      def user_params
        params.permit(:nome, :email)
      end

      def user_update_params
        params.permit(:nome, :email)
      end

      def password_params
        params.permit(:password, :password_confirmation)
      end
    end
  end
end
