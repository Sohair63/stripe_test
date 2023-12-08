# frozen_string_literal: true

# Creates a stripe charge
#
class CreateCharge < ApplicationInteractor
  delegate :charge_params, :charge, to: :context

  # @!method self.call(charge_params:)
  #   @param charge_params [Array<Hash>] Charge params
  #
  #   @return [Interactor::Context]

  def call
    context.charge = Services::Stripe.create_charge(charge_params.to_h)
  rescue Services::Api::Error => e
    error(e.message)
  end
end
