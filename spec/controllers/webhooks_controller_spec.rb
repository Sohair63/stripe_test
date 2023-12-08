require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe 'POST #create' do
    let(:params) { { source: 'stripe', data: '{"key": "value"}', headers: { 'CONTENT_TYPE' => 'application/json' } } }

    before do
      allow(WebhookProcessor).to receive(:parse_id).and_return('webhook_id')
      allow(WebhookProcessor).to receive(:process).and_return(an_instance_of(Webhook))
    end

    context 'when request method is POST' do
      it 'creates a new webhook and processes it' do
        post :create, params: params

        expect(response).to have_http_status(:ok)
        expect(Webhook.count).to eq(1)
        expect(Webhook.last.source).to eq('stripe')
        expect(WebhookProcessor).to have_received(:process).with(an_instance_of(Webhook))
      end

      it 'returns :bad_request if saving the webhook fails' do
        allow_any_instance_of(Webhook).to receive(:save).and_return(false)

        post :create, params: params

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns :ok if the webhook has already been processed' do
        allow_any_instance_of(Webhook).to receive(:save).and_return(true)
        allow(Webhook).to receive(:exists?).and_return(true)

        post :create, params: params

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
