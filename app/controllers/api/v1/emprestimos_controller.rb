module Api
  module V1
    class EmprestimosController < BaseController
      before_action :set_emprestimo, only: [:show, :devolver, :renovar]

      def index
        emprestimos = policy_scope(Emprestimo).includes(:livro, :usuario_biblioteca).order(created_at: :desc)
        render json: emprestimos.map { |e| emprestimo_json(e) }
      end

      def show
        authorize @emprestimo
        render json: emprestimo_json(@emprestimo)
      end

      def create
        authorize Emprestimo

        usuario = UsuarioBiblioteca.find_by(id: params[:usuario_biblioteca_id])
        return render json: { error: "Cidadao nao encontrado" }, status: :not_found unless usuario

        unless usuario.senha_emprestimo == params[:senha_emprestimo]
          return render json: { error: "Senha de emprestimo invalida" }, status: :unauthorized
        end

        livro = Livro.find_by(id: params[:livro_id])
        return render json: { error: "Livro nao encontrado" }, status: :not_found unless livro

        emprestimo = Emprestimo.new(
          livro: livro,
          usuario_biblioteca: usuario,
          data_emprestimo: Time.current
        )

        if emprestimo.save
          livro.update!(status: :emprestado)
          render json: emprestimo_json(emprestimo), status: :created
        else
          render json: { errors: emprestimo.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def devolver
        authorize @emprestimo, :devolver?

        unless @emprestimo.ativo? || @emprestimo.atrasado?
          return render json: { error: "Emprestimo ja foi devolvido" }, status: :unprocessable_entity
        end

        @emprestimo.devolver!

        if @emprestimo.atrasado?
          @emprestimo.create_multa!(valor: 2.0)
        end

        render json: emprestimo_json(@emprestimo)
      end

      def renovar
        authorize @emprestimo, :renovar?

        unless @emprestimo.ativo?
          return render json: { error: "Apenas emprestimos ativos podem ser renovados" }, status: :unprocessable_entity
        end

        @emprestimo.renovar!
        render json: emprestimo_json(@emprestimo)
      end

      def atrasados
        authorize Emprestimo, :atrasados?
        emprestimos = Emprestimo.atrasados.includes(:livro, :usuario_biblioteca).order(data_devolucao_prevista: :asc)
        render json: emprestimos.map { |e| emprestimo_json(e) }
      end

      def historico
        authorize Emprestimo, :historico?
        usuario = UsuarioBiblioteca.find_by(id: params[:usuario_biblioteca_id])
        return render json: { error: "Cidadao nao encontrado" }, status: :not_found unless usuario

        emprestimos = Emprestimo.where(usuario_biblioteca: usuario).includes(:livro).order(created_at: :desc)
        render json: emprestimos.map { |e| emprestimo_json(e) }
      end

      private

      def set_emprestimo
        @emprestimo = Emprestimo.includes(:livro, :usuario_biblioteca).find_by(id: params[:id])
        render json: { error: "Emprestimo nao encontrado" }, status: :not_found unless @emprestimo
      end

      def emprestimo_json(emprestimo)
        {
          id: emprestimo.id,
          status: emprestimo.status,
          data_emprestimo: emprestimo.data_emprestimo,
          data_devolucao_prevista: emprestimo.data_devolucao_prevista,
          data_devolucao_real: emprestimo.data_devolucao_real,
          renovacoes: emprestimo.renovacoes,
          dias_atraso: emprestimo.dias_atraso,
          livro: {
            id: emprestimo.livro.id,
            titulo: emprestimo.livro.titulo,
            autor: emprestimo.livro.autor
          },
          usuario_biblioteca: {
            id: emprestimo.usuario_biblioteca.id,
            nome_completo: emprestimo.usuario_biblioteca.nome_completo,
            cpf: emprestimo.usuario_biblioteca.cpf
          },
          multa: emprestimo.multa ? { id: emprestimo.multa.id, valor: emprestimo.multa.valor, pago: emprestimo.multa.pago } : nil,
          created_at: emprestimo.created_at
        }
      end
    end
  end
end
