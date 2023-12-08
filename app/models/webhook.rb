# frozen_string_literal: true

# Webhook model to store incoming webhook events
#
class Webhook < ApplicationRecord
  #
  # Attributes
  #
  attribute :id, :integer
  attribute :source, :string
  attribute :webhook_id, :string
  attribute :event, :string
  attribute :data, :text
  attribute :headers, :jsonb # JSON Binary (queryable/indexable)
  attribute :processed, :boolean
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  #
  # Validations
  #
  validates :source, :data, presence: true

  # Returns the webhook data parsed as JSON
  #
  def json_data
    JSON.parse(data)
  rescue JSON::ParserError
    {}
  end
end
