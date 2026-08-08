module Api
  module V1
    class PerfisController < BaseController
      before_action :set_perfil

      def show
        render json: perfil_json(@perfil)
      end

      def update
        if @perfil.update(perfil_params)
          render json: perfil_json(@perfil)
        else
          render json: { errors: @perfil.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

     def set_perfil
  @perfil = current_user.usuario_biblioteca&.tap { |p| p.association(:endereco).load_target }
  render json: { error: "Perfil nao encontrado" }, status: :not_found unless @perfil
end

      def perfil_params
        params.permit(:nome_completo, :telefone, :senha_emprestimo,
          endereco_attributes: [:cep, :logradouro, :bairro, :cidade, :uf, :numero, :complemento])
      end

      def perfil_json(perfil)
        {
          id: perfil.id,
          nome_completo: perfil.nome_completo,
          cpf: perfil.cpf,
          telefone: perfil.telefone,
          email: perfil.user.email,
          senha_emprestimo: perfil.senha_emprestimo,
          numero_carteirinha: perfil.numero_carteirinha,
          status_carteirinha: perfil.status_carteirinha,
          endereco: perfil.endereco && {
            cep: perfil.endereco.cep,
            logradouro: perfil.endereco.logradouro,
            bairro: perfil.endereco.bairro,
            cidade: perfil.endereco.cidade,
            uf: perfil.endereco.uf,
            numero: perfil.endereco.numero,
            complemento: perfil.endereco.complemento
          },
          created_at: perfil.created_at
        }
      end
    end
  end
end