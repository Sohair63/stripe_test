# frozen_string_literal: true

module WebhookProcessor
  # Processes a charge.refunded webhook for stripe
  #
  class ChargeRefunded
    include Interactor
    delegate :webhook, to: :context

    def call
      Rails.logger.info 'Processed a charge.refunded webhook for stripe'
    end
  end
end
