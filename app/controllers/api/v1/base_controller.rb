module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_request!

      private

      def authenticate_request!
        if request.headers["Authorization"].present?
          token = request.headers["Authorization"].split(" ").last
          begin
            jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(token)
            @current_user = User.find_by(jti: jwt_payload["jti"])

            if @current_user.nil?
              render json: { error: "Token inválido" }, status: :unauthorized
            end
          rescue JWT::ExpiredSignature
            render json: { error: "Token expirado" }, status: :unauthorized
          rescue JWT::DecodeError
            render json: { error: "Token inválido" }, status: :unauthorized
          end
        else
          render json: { error: "Token não fornecido" }, status: :unauthorized
        end
      end

      def current_user
        @current_user
      end
    end
  end
end
