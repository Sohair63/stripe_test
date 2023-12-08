# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebhookProcessor do
  let(:webhook) { create :webhook, source: :stripe, data: {id: "ch_123456789", type: "charge.succeeded"}.to_json }

  before { allow(Stripe::Webhook).to receive(:construct_event).and_return(true) }

  describe "#process" do
    before { described_class.process(webhook) }

    it { expect(webhook.webhook_id).to eq "ch_123456789" }
    it { expect(webhook.event).to eq "charge.succeeded" }
    it { expect(webhook).to be_processed }

    context "when the type is charge.succeeded" do
      before { allow_any_instance_of(WebhookProcessor::ChargeSucceeded).to receive(:call) }

      it "is expected to call WebhookProcessor::ChargeSucceeded" do
        expect_any_instance_of(WebhookProcessor::ChargeSucceeded).to receive(:call)
        described_class.process(webhook)
      end
    end

    context "when the type is charge.refunded" do
      let(:webhook) { create :webhook, source: :stripe, data: {id: "ch_123456789", type: "charge.refunded"}.to_json }
      before { allow_any_instance_of(WebhookProcessor::ChargeRefunded).to receive(:call) }

      it "is expected to call WebhookProcessor::ChargeRefunded" do
        expect_any_instance_of(WebhookProcessor::ChargeRefunded).to receive(:call)
        described_class.process(webhook)
      end
    end
  end
end
