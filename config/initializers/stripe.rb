# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Services::Stripe.configure
end
