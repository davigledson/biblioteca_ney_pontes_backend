module Api
  module V1
    class UsuarioBibliotecasController < BaseController
      before_action :set_usuario, only: [:show, :update, :destroy, :carteirinha]

      def carteirinha
        authorize @usuario
        render json: {
          id: @usuario.id,
          nome_completo: @usuario.nome_completo,
          cpf: @usuario.cpf,
          email: @usuario.user.email,
          numero_carteirinha: @usuario.numero_carteirinha,
          status_carteirinha: @usuario.status_carteirinha,
          telefone: @usuario.telefone,
          created_at: @usuario.created_at
        }
      end

      def index
        authorize UsuarioBiblioteca
        usuarios = policy_scope(UsuarioBiblioteca).includes(:user).order(created_at: :desc)
        render json: usuarios.map { |u| usuario_json(u) }
      end

      def show
        authorize @usuario
        render json: usuario_json(@usuario)
      end

      def create
        authorize UsuarioBiblioteca

        ActiveRecord::Base.transaction do
          user = User.new(
            nome: params[:nome_completo]&.split&.first || params[:nome_completo],
            email: params[:email],
            password: SecureRandom.hex(8),
            role: :cidadao
          )
          user.save!

          usuario = user.build_usuario_biblioteca(usuario_params.merge(
            senha_emprestimo: SecureRandom.hex(3)
          ))
          usuario.save!

          UserMailer.senha_emprestimo(usuario).deliver_later

          render json: usuario_json(usuario), status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        authorize @usuario
        if @usuario.update(usuario_params)
          render json: usuario_json(@usuario)
        else
          render json: { errors: @usuario.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @usuario
        @usuario.destroy
        head :no_content
      end

      private

      def set_usuario
        @usuario = UsuarioBiblioteca.includes(:user).find_by(id: params[:id])
        render json: { error: "Cidadao nao encontrado" }, status: :not_found unless @usuario
      end

      def usuario_params
        params.permit(:nome_completo, :cpf, :telefone)
      end

      def usuario_json(usuario)
        {
          id: usuario.id,
          nome_completo: usuario.nome_completo,
          cpf: usuario.cpf,
          telefone: usuario.telefone,
          email: usuario.user.email,
          senha_emprestimo: usuario.senha_emprestimo,
          created_at: usuario.created_at
        }
      end
    end
  end
end
