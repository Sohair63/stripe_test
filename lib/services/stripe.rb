# frozen_string_literal: true

module Services
  #
  # Provides an interface to use library methods of stripe gem
  #
  class Stripe
    #
    # Stripe Service Class Methods
    #

    class << self
      #
      # Configuration
      #

      def configure
        ::Stripe.api_key = secret_key
      end

      def create_charge(params)
        rescue_errors { ::Stripe::Charge.create(params) }
      end

      def create_refund(params)
        rescue_errors { ::Stripe::Refund.create(params) }
      end

      private

      def secret_key
        Rails.application.credentials.stripe[:secret_key]
      end

      def rescue_errors
        yield
      rescue ::Stripe::StripeError => e
        raise Services::Api::Error, e.inspect
      end
    end
  end
end
