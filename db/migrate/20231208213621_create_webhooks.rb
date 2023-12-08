# frozen_string_literal: true

# webhooks table migration
#
class CreateWebhooks < ActiveRecord::Migration[7.1]
  def change
    create_table :webhooks do |t|
      t.string :source
      t.string :event
      t.text :data
      t.string :webhook_id, index: true
      t.boolean :processed, default: false
      t.jsonb :headers, null: false, default: {}

      t.timestamps
    end
  end
end
