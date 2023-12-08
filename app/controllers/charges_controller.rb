# frozen_string_literal: true
#
# Used to manage requests to handle Stripe charges.
#
class ChargesController < ApplicationController
  def create
    @result = CreateCharge.call(charge_params:)

    if @result.success?
      render_okay @result.charge
    else
      render_unprocessable_entity @result.error
    end
  end

  def refund
    @result = CreateRefund.call(refund_params:)

    if @result.success?
      render_okay @result.refund
    else
      render_unprocessable_entity @result.error
    end
  end

  private

  def charge_params
    params.require(:charge).permit(%i[amount currency source])
  end

  def refund_params
    params.require(:refund).permit(%i[charge])
  end
end
