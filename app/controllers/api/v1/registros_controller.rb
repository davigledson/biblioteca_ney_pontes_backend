module Api
  module V1
    class RegistrosController < ApplicationController
      def create
        ActiveRecord::Base.transaction do
          user = User.new(registro_user_params.merge(role: :cidadao))
          user.save!

          usuario = user.build_usuario_biblioteca(registro_params)
          usuario.save!

          UserMailer.senha_emprestimo(usuario).deliver_later

          token = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil).first

          render json: {
            message: "Cadastro realizado com sucesso",
            user: {
              id: user.id,
              nome: user.nome,
              email: user.email,
              role: user.role
            },
            usuario_biblioteca: {
              id: usuario.id,
              nome_completo: usuario.nome_completo,
              cpf: usuario.cpf,
              telefone: usuario.telefone,
              senha_emprestimo: usuario.senha_emprestimo
            },
            token: token
          }, status: :created
        end
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      private

      def registro_user_params
        params.permit(:nome, :email, :password, :password_confirmation)
      end

      def registro_params
        params.permit(:nome_completo, :cpf, :telefone, :senha_emprestimo)
      end
    end
  end
end
