class WebhooksController < ApplicationController
  # GET/POST /webhooks/:source
  #
  def create
    @webhook = Webhook.new(source: params[:source], data: request_data, headers: request_headers)
    return head :ok if already_processed?

    if @webhook.save
      WebhookProcessor.process(@webhook)
      head :ok
    else
      head :bad_request
    end
  end

  private

  def request_data
    return request.raw_post if request.post?
    request.query_parameters.to_json
  end

  def request_headers
    request
      .env
      .select { |k, _| k =~ /^HTTP_/ }
      .transform_keys { |k| k.sub(/^HTTP_/, '') }
  end

  def already_processed?
    webhook_id = WebhookProcessor.parse_id(@webhook)
    Webhook.exists?(webhook_id:)
  end
end
