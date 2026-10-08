module Api
  module V1
    module Payments
      class CheckoutSessionsController < ApplicationController
        before_action :authenticate_user!

        def create
          result = CheckoutSessionCreator.new(user: current_user).call
          render json: {
            data: {
              checkout_session_id: result.session_id,
              checkout_url: result.checkout_url,
            },
          }, status: :created
        rescue CheckoutSessionCreator::AlreadyActiveError
          render_error(:membership_already_active, "すでに有料コンテンツを利用できます", :conflict)
        rescue CheckoutSessionCreator::SessionInProgressError
          render_error(:checkout_session_in_progress, "未完了の決済があります", :conflict)
        rescue CheckoutSessionCreator::ConfigurationError
          render_error(:payment_unavailable, "現在、決済を開始できません", :service_unavailable)
        rescue Stripe::StripeError
          Rails.logger.error("Stripe Checkout Session creation failed")
          render_error(:payment_provider_error, "決済サービスへ接続できませんでした", :bad_gateway)
        end
      end
    end
  end
end
