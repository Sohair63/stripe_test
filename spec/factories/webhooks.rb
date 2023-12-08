# frozen_string_literal: true

FactoryBot.define do
  factory :webhook do
    source { "source" }
    webhook_id { "id" }
    event { "charge.succeeded" }
    data { {id: "webhook_id", type: "stripe"}.to_json }
    headers { {"key" => "value"} }
    processed { false }
  end
end
