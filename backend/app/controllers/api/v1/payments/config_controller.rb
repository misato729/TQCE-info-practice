module Api
  module V1
    module Payments
      class ConfigController < ApplicationController
        def show
          render json: {
            data: {
              enabled: PaidMembership.enabled?,
              amount: PaidMembership::AMOUNT,
              currency: PaidMembership::CURRENCY,
              purchase_type: "one_time",
              free_exam_max: PaidMembership::FREE_EXAM_MAX,
              seller: PaidMembership.seller_information,
            },
          }
        end
      end
    end
  end
end
