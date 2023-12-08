
# frozen_string_literal: true

# Processes various types of webhooks
#
module WebhookProcessor
  module_function

  # Processes the webhook and updates the processed flag if successful
  #
  # @param webhook [Webhook] Webhook model
  #
  # @return [Interactor::Context]
  #
  def process(webhook)
    webhook.update(
      webhook_id: parse_id(webhook),
      event: parse_event(webhook)
    )

    return unless verified?(webhook)

    processor = const_get(webhook.event.tr('.', '_').camelcase)
    result = processor.call(webhook:)
    webhook.update(processed: true) if result.success?
  end

  # Verifies the passed webhook against the signature included in the
  # request header
  #
  # @param webhook [Webhook] Webhook model
  #
  # @return [Boolean]
  #
  def verified?(webhook)
    case webhook.source
    when 'stripe'
      stripe_verified?(webhook)
    end
  end

  # Parses the webhook id from the post data or headers
  #
  # @param webhook [Webhook] Webhook model
  #
  # @return [String] Webhook ID
  #
  def parse_id(webhook)
    case webhook.source
    when 'stripe'
      webhook.json_data['id']
    end
  end

  # Parses the webhook event type from the post data or headers
  #
  # @param webhook [Webhook] Webhook model
  #
  # @return [String] Webhook event
  #
  def parse_event(webhook)
    case webhook.source
    when 'stripe'
      webhook.json_data['type']
    end
  end

  # private

  def stripe_verified?(webhook)
    Stripe::Webhook.construct_event(
      webhook.data,
      webhook.headers['STRIPE_SIGNATURE'],
      Rails.application.credentials.stripe[:webhook_secret]
    )
    true
  rescue JSON::ParserError
    false
  rescue Stripe::SignatureVerificationError
    false
  end

  private_class_method :stripe_verified?
end
