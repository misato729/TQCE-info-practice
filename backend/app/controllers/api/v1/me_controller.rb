module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: {
          data: {
            id: current_user.id,
            name: current_user.name,
            email: current_user.email,
            role: current_user.role,
            created_at: current_user.created_at.iso8601,
          },
        }
      end
    end
  end
end
