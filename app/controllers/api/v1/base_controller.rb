module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization

      before_action :authenticate_api_v1_user!

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

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
