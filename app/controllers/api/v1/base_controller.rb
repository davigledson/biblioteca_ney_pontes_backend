module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization
      include Pagy::Method

      before_action :authenticate_api_v1_user!

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def paginar(relacao)
        paginacao, itens = pagy(:offset, relacao,
                                limit: 10,
                                client_max_limit: 100,
                                page_key: 'page',
                                limit_key: 'per_page')

        response.headers['X-Page'] = paginacao.page.to_s
        response.headers['X-Per-Page'] = paginacao.limit.to_s
        response.headers['X-Total'] = paginacao.count.to_s
        response.headers['X-Total-Pages'] = paginacao.pages.to_s

        itens
      end

      def current_user
        current_api_v1_user
      end

      def pundit_user
        current_api_v1_user
      end

      def user_not_authorized
        render json: { error: "Acesso negado" }, status: :forbidden
      end
    end
  end
end