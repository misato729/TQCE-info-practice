module Api
  module V1
    class HealthController < ApplicationController
      def show
        render json: {
          status: "ok",
          app: "TQCE API"
        }
      end
    end
  end
end
