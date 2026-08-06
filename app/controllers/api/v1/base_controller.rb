module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_api_v1_user!

      private

      def current_user
        current_api_v1_user
      end
    end
  end
end
