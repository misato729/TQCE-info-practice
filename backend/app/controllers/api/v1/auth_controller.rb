module Api
  module V1
    class AuthController < ApplicationController
      def signup
        user = User.new(signup_params)

        if user.save
          render json: { data: session_data(user) }, status: :created
        else
          render_error(
            :validation_error,
            "入力内容を確認してください",
            :unprocessable_content,
            details: user.errors.to_hash,
          )
        end
      end

      def login
        user = User.find_by(email: params[:email].to_s.strip.downcase)

        unless user&.authenticate(params[:password].to_s)
          return render_error(:unauthorized, "メールアドレスまたはパスワードが正しくありません", :unauthorized)
        end

        render json: { data: session_data(user) }
      end

      private

      def signup_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def session_data(user)
        {
          access_token: AuthToken.issue(user),
          token_type: "Bearer",
          expires_in: AuthToken::EXPIRES_IN.to_i,
          user: serialize_user(user),
        }
      end

      def serialize_user(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
        }
      end
    end
  end
end
