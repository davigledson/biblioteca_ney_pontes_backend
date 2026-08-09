module Api
  module V1
    class LivrosController < BaseController
      skip_before_action :authenticate_api_v1_user!, only: :capa
      before_action :set_livro, only: [:show, :update, :destroy, :historico, :capa]

      def index
        livros = Livro.includes(:categoria).order(created_at: :desc)

        if params[:q].present?
          termo = "%#{params[:q].strip}%"
          livros = livros.where("titulo ILIKE :termo OR autor ILIKE :termo", termo: termo)
        end
        livros = livros.where(categoria_id: params[:categoria_id]) if params[:categoria_id].present?
        livros = livros.where(status: params[:status]) if params[:status].present?

        livros = paginar(livros)
        render json: livros.map { |l| livro_json(l) }
      end

      def show
        render json: livro_json(@livro)
      end

      def create
        livro = Livro.new(livro_params)
        livro.capa.attach(params[:capa]) if params[:capa].present?

        if livro.save
          livro.sincronizar_capa_blob_id!
          render json: livro_json(livro), status: :created
        else
          render json: { errors: livro.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @livro.remover_capa! if params[:remover_capa] == "true"
        @livro.capa.attach(params[:capa]) if params[:capa].present?

        if @livro.update(livro_params)
          @livro.sincronizar_capa_blob_id!
          render json: livro_json(@livro)
        else
          render json: { errors: @livro.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @livro.destroy
        head :no_content
      end

      def capa
      return head :not_found unless @livro.capa.attached?

      variant = @livro.capa.variant(resize_to_limit: [600, 900], format: :webp, saver: { quality: 80 })
      variant.processed

      headers["Cache-Control"] = "public, max-age=31536000, immutable"
      send_data @livro.capa.blob.service.download(variant.key),
        type: "image/webp",
        disposition: "inline",
        filename: "capa-#{@livro.id}.webp"
    rescue Vips::Error, ActiveStorage::IntegrityError
      headers["Cache-Control"] = "public, max-age=31536000, immutable"
      send_data @livro.capa.download,
        type: @livro.capa.content_type,
        disposition: "inline",
        filename: @livro.capa.filename.to_s
    end

    def historico
        base = Emprestimo.where(livro: @livro)
        emprestimos = paginar(base.includes(:usuario_biblioteca).order(created_at: :desc))

        resumo = {
          total: base.count,
          atuais: base.where.not(status: :devolvido).count,
          devolvidos: base.where(status: :devolvido).count,
          atrasados: Emprestimo.atrasados.where(livro: @livro).count
        }

        render json: {
          livro: livro_json(@livro),
          emprestimos: emprestimos.map { |e| EmprestimoSerializer.call(e) },
          resumo: resumo
        }
      end

      private

      def set_livro
        @livro = Livro.find_by(id: params[:id])
        render json: { error: "Livro nao encontrado" }, status: :not_found unless @livro
      end

      def livro_params
        p = params.permit(:titulo, :autor, :categoria_id, :status, :observacoes, :capa)
        p[:status] = p[:status].to_i if p[:status].present?
        p
      end

      def livro_json(livro)
        {
          id: livro.id,
          titulo: livro.titulo,
          autor: livro.autor,
          status: livro.status,
          observacoes: livro.observacoes,
          capa_url: livro.capa.attached? ? "/api/v1/livros/#{livro.id}/capa?v=#{livro.updated_at.to_i}" : nil,
          categoria: {
            id: livro.categoria.id,
            nome: livro.categoria.nome
          },
          created_at: livro.created_at,
          updated_at: livro.updated_at
        }
      end
    end
  end
end
