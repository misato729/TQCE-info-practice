module Api
  module V1
    module Webhooks
      class StripeController < ApplicationController
        def create
          return render_error(:webhook_unavailable, "Webhook設定が完了していません", :service_unavailable) if webhook_secret.blank?

          event = ::Stripe::Webhook.construct_event(
            request.raw_post,
            request.headers["Stripe-Signature"],
            webhook_secret,
          )
          StripeWebhookProcessor.new(event: event).call
          head :ok
        rescue JSON::ParserError, ::Stripe::SignatureVerificationError
          render_error(:invalid_webhook, "Webhookを検証できません", :bad_request)
        rescue StripeWebhookProcessor::EnvironmentMismatchError, StripeWebhookProcessor::EventMismatchError
          render_error(:invalid_webhook, "Webhookの内容を確認できません", :bad_request)
        rescue StripeWebhookProcessor::PaymentNotReadyError,
          ActiveRecord::RecordNotFound,
          ActiveRecord::RecordInvalid,
          ActiveRecord::RecordNotUnique,
          ::Stripe::StripeError,
          KeyError => error
          Rails.logger.error("Stripe webhook processing failed: #{error.class.name}")
          render_error(:webhook_processing_failed, "Webhookを処理できませんでした", :internal_server_error)
        end

        private

        def webhook_secret
          ENV["STRIPE_WEBHOOK_SECRET"]
        end
      end
    end
  end
end
