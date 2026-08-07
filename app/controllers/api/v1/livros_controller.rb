module Api
  module V1
    class LivrosController < BaseController
      before_action :set_livro, only: [:show, :update, :destroy]

      def index
        livros = Livro.includes(:categoria).all.order(created_at: :desc)
        render json: livros.map { |l| livro_json(l) }
      end

      def show
        render json: livro_json(@livro)
      end

      def create
        livro = Livro.new(livro_params)

        if livro.save
          render json: livro_json(livro), status: :created
        else
          render json: { errors: livro.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @livro.update(livro_params)
          render json: livro_json(@livro)
        else
          render json: { errors: @livro.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @livro.destroy
        head :no_content
      end

      private

      def set_livro
        @livro = Livro.find_by(id: params[:id])
        render json: { error: "Livro nao encontrado" }, status: :not_found unless @livro
      end

      def livro_params
        params.permit(:titulo, :autor, :categoria_id, :status, :observacoes)
      end

      def livro_json(livro)
        {
          id: livro.id,
          titulo: livro.titulo,
          autor: livro.autor,
          status: livro.status,
          observacoes: livro.observacoes,
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
