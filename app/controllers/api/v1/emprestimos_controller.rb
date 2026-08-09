module Api
  module V1
    class EmprestimosController < BaseController
      before_action :set_emprestimo, only: [:show, :devolver, :renovar]

      def index
        emprestimos = policy_scope(Emprestimo).includes(:livro, :usuario_biblioteca).order(created_at: :desc)
        emprestimos = filtrar_por_term(emprestimos) if params[:q].present?
        render json: paginar(emprestimos).map { |e| EmprestimoSerializer.call(e) }
      end

      def show
        authorize @emprestimo
        render json: EmprestimoSerializer.call(@emprestimo)
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
          render json: EmprestimoSerializer.call(emprestimo), status: :created
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

        render json: EmprestimoSerializer.call(@emprestimo)
      end

      def renovar
        authorize @emprestimo, :renovar?

        unless @emprestimo.ativo?
          return render json: { error: "Apenas emprestimos ativos podem ser renovados" }, status: :unprocessable_entity
        end

        @emprestimo.renovar!
        render json: EmprestimoSerializer.call(@emprestimo)
      end

      def atrasados
        authorize Emprestimo, :atrasados?
        emprestimos = Emprestimo.atrasados.includes(:livro, :usuario_biblioteca).order(data_devolucao_prevista: :asc)
        emprestimos = filtrar_por_term(emprestimos) if params[:q].present?
        render json: paginar(emprestimos).map { |e| EmprestimoSerializer.call(e) }
      end

      def historico
        authorize Emprestimo, :historico?
        usuario = UsuarioBiblioteca.find_by(id: params[:usuario_biblioteca_id])
        return render json: { error: "Cidadao nao encontrado" }, status: :not_found unless usuario

        base = Emprestimo.where(usuario_biblioteca: usuario)
        emprestimos = paginar(base.includes(:livro).order(created_at: :desc))

        resumo = {
          total: base.count,
          ativos: base.ativos.count,
          atrasados: Emprestimo.atrasados.where(usuario_biblioteca: usuario).count,
          multas_pendentes: Multa
            .joins(:emprestimo)
            .where(emprestimos: { usuario_biblioteca_id: usuario.id }, pago: false)
            .sum(:valor)
            .to_f
        }

        render json: {
          emprestimos: emprestimos.map { |e| EmprestimoSerializer.call(e) },
          resumo: resumo
        }
      end

      def pagar_multa
        authorize @emprestimo, :pagar_multa?

        multa = @emprestimo.multa
        return render json: { error: "Nao ha multa para este emprestimo" }, status: :not_found unless multa
        return render json: { error: "Multa ja foi paga" }, status: :unprocessable_entity if multa.pago?

        multa.update!(pago: true)
        render json: { message: "Multa registrada como paga" }
      end

      private

      def filtrar_por_term(scope)
        termo = "%#{params[:q].strip}%"
        scope
          .joins(:livro, :usuario_biblioteca)
          .where("livros.titulo ILIKE :t OR usuario_bibliotecas.nome_completo ILIKE :t", t: termo)
      end

      def set_emprestimo
        @emprestimo = Emprestimo.includes(:livro, :usuario_biblioteca).find_by(id: params[:id])
        render json: { error: "Emprestimo nao encontrado" }, status: :not_found unless @emprestimo
      end
    end
  end
end
