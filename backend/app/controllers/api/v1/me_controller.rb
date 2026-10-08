module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!

      def show
        render json: { data: UserPayload.call(current_user) }
      end

      def destroy
        unless current_user.authenticate(params[:current_password].to_s)
          return render_error(
            :validation_error,
            "現在のパスワードを確認してください",
            :unprocessable_content,
            details: { current_password: ["が正しくありません"] },
          )
        end

        User.transaction do
          current_user.lock!
          PendingCheckoutExpirer.new(user: current_user).call
          current_user.destroy!
        end
        head :no_content
      rescue PendingCheckoutExpirer::PaymentProcessingError
        render_error(
          :checkout_session_in_progress,
          "決済完了通知を確認中のため、しばらく待ってから再度お試しください",
          :conflict,
        )
      rescue PendingCheckoutExpirer::EnvironmentMismatchError, KeyError
        render_error(:payment_unavailable, "決済状態を確認できないため、アカウントを削除できません", :service_unavailable)
      rescue Stripe::StripeError
        Rails.logger.error("Failed to expire pending Stripe Checkout Session before account deletion")
        render_error(:payment_provider_error, "決済状態を確認できないため、アカウントを削除できません", :bad_gateway)
      end
    end
  end
end
