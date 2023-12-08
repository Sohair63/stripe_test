require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Services::Stripe do
  let(:secret_key) { Rails.application.credentials.stripe[:secret_key] }

  before { described_class.configure }

  describe '.configure' do
    it 'configures the Stripe gem with the correct secret key' do
      expect(::Stripe.api_key).to eq(secret_key)
    end
  end

  describe '.create_charge' do
    context 'when successfull' do
      let(:response) { Stripe::StripeObject.new(id: 'ch_1234567890') }
      let(:params) { { amount: 100, currency: 'usd', source: 'tok_visa' } }

      before { stub_stripe_charge_create }

      it { expect { described_class.create_charge(params) }.not_to raise_error }
      it { expect(described_class.create_charge(params)).to eq response }
    end

    context 'when failed' do
      let(:params) { { amount: 100, currency: 'usd', source: 'invalid_token' } }

      before { stub_stripe_charge_create_failure }

      it { expect { described_class.create_charge(params) }.to raise_error(Services::Api::Error) }
    end
  end

  describe '.create_refund' do
    context 'when successfull' do
      let(:response) { Stripe::StripeObject.new(id: 're_1234567890') }
      let(:params) { { charge: 'ch_1234567890', amount: 50 } }

      before { stub_stripe_refund_create }

      it { expect { described_class.create_refund(params) }.not_to raise_error }
      it { expect(described_class.create_refund(params)).to eq response }
    end

    context 'when failed' do
      let(:params) { { charge: 'ch_1234567890', amount: 60 } }

      before { stub_stripe_refund_create_failure }

      it { expect { described_class.create_refund(params) }.to raise_error(Services::Api::Error) }
    end
  end

  private

  def stub_stripe_charge_create
    stub_request(:post, 'https://api.stripe.com/v1/charges')
      .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })
  end

  def stub_stripe_charge_create_failure
    stub_request(:post, 'https://api.stripe.com/v1/charges')
      .to_return(status: 402, body: '{"error": {"message": "Card declined", "type": "card_error"}}', headers: { 'Content-Type': 'application/json' })
  end

  def stub_stripe_refund_create
    stub_request(:post, 'https://api.stripe.com/v1/refunds')
      .to_return(status: 200, body: response.to_json, headers: { 'Content-Type': 'application/json' })
  end

  def stub_stripe_refund_create_failure
    stub_request(:post, 'https://api.stripe.com/v1/refunds')
      .to_return(status: 402, body: '{"error": {"message": "Refund failed", "type": "invalid_request_error"}}', headers: { 'Content-Type': 'application/json' })
  end
end
