module Api
  module V1
    class UsuarioBibliotecasController < BaseController
      before_action :set_usuario, only: [:show, :update, :destroy, :carteirinha, :enviar_senha_emprestimo]

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

      def enviar_senha_emprestimo
        authorize @usuario, :enviar_senha_emprestimo?
        UserMailer.senha_emprestimo(@usuario).deliver_later
        render json: { message: "Senha de emprestimo enviada para #{@usuario.user.email}" }
      end

      def index
        authorize UsuarioBiblioteca
        usuarios = paginar(policy_scope(UsuarioBiblioteca).includes(:user).order(created_at: :desc))
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
  @usuario = UsuarioBiblioteca.includes(:user, :endereco).find_by(id: params[:id])
  render json: { error: "Cidadao nao encontrado" }, status: :not_found unless @usuario
end

      def usuario_params
  params.permit(:nome_completo, :cpf, :telefone,
    endereco_attributes: [:cep, :logradouro, :bairro, :cidade, :uf, :numero, :complemento])
end

      def usuario_json(usuario)
  {
    id: usuario.id,
    nome_completo: usuario.nome_completo,
    cpf: usuario.cpf,
    telefone: usuario.telefone,
    email: usuario.user.email,
    senha_emprestimo: usuario.senha_emprestimo,
    endereco: usuario.endereco && {
      cep: usuario.endereco.cep,
      logradouro: usuario.endereco.logradouro,
      bairro: usuario.endereco.bairro,
      cidade: usuario.endereco.cidade,
      uf: usuario.endereco.uf,
      numero: usuario.endereco.numero,
      complemento: usuario.endereco.complemento
    },
    created_at: usuario.created_at
  }
end
    end
  end
end
