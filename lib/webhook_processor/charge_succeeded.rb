module WebhookProcessor
  # Processes a charge.succeeded webhook for stripe
  #
  class ChargeSucceeded
    include Interactor
    delegate :webhook, to: :context

    def call
      Rails.logger.info 'Processed a charge.succeeded webhook for stripe'
    end
  end
end
