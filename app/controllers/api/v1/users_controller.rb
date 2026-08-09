module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy, :change_password]

      def index
        authorize User
        users = User.bibliotecario.order(created_at: :desc)
        if params[:q].present?
          termo = "%#{params[:q].strip}%"
          users = users.where("nome ILIKE :t OR email ILIKE :t", t: termo)
        end
        render json: paginar(users).map { |u| u.as_json(only: [:id, :nome, :email, :role, :first_login, :created_at]) }
      end

      def show
        authorize @user
        render json: @user.as_json(only: [:id, :nome, :email, :role, :first_login, :created_at])
      end

      def create
        authorize User
        temp_password = SecureRandom.hex(8)
        user = User.new(user_params.merge(password: temp_password, password_confirmation: temp_password, role: :bibliotecario))

        if user.save
          UserMailer.credenciais_acesso(user, temp_password).deliver_later
          render json: {
            message: "Bibliotecario cadastrado com sucesso. A senha temporaria foi enviada para o email do bibliotecario.",
            user: {
              id: user.id,
              nome: user.nome,
              email: user.email,
              role: user.role,
              first_login: user.first_login
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize @user
        if @user.update(user_update_params)
          render json: {
            message: "Bibliotecario atualizado com sucesso",
            user: { id: @user.id, nome: @user.nome, email: @user.email, role: @user.role, first_login: @user.first_login }
          }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @user
        @user.destroy
        render json: { message: "Bibliotecario removido com sucesso" }, status: :ok
      end

      def change_password
        authorize @user, :change_password?
        if @user.update(password_params.merge(first_login: false))
          render json: { message: "Senha alterada com sucesso" }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
        render json: { error: "Bibliotecario nao encontrado" }, status: :not_found unless @user
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
