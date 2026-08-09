module Api
  module V1
    class CategoriasController < BaseController
      before_action :set_categoria, only: [:show, :update, :destroy]

      def index
        categorias = Categoria.order(created_at: :desc)
        if params[:q].present?
          categorias = categorias.where("nome ILIKE :termo", termo: "%#{params[:q].strip}%")
        end
        render json: paginar(categorias).as_json(only: [:id, :nome, :created_at])
      end

      def show
        render json: @categoria.as_json(only: [:id, :nome, :created_at])
      end

      def create
        categoria = Categoria.new(categoria_params)

        if categoria.save
          render json: categoria.as_json(only: [:id, :nome, :created_at]), status: :created
        else
          render json: { errors: categoria.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @categoria.update(categoria_params)
          render json: @categoria.as_json(only: [:id, :nome, :created_at])
        else
          render json: { errors: @categoria.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @categoria.destroy
        head :no_content
      end

      private

      def set_categoria
        @categoria = Categoria.find_by(id: params[:id])
        render json: { error: "Categoria não encontrada" }, status: :not_found unless @categoria
      end

      def categoria_params
        params.permit(:nome)
      end
    end
  end
end
