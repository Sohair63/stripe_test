# frozen_string_literal: true

# Creates a stripe refund
#
class CreateRefund < ApplicationInteractor
  delegate :refund_params, :refund, to: :context

  # @!method self.call(refund_params:)
  #   @param refund_params [Array<Hash>] Refund params
  #
  #   @return [Interactor::Context]

  def call
    context.refund = Services::Stripe.create_refund(refund_params.to_h)
  rescue Services::Api::Error => e
    error(e.message)
  end
end
