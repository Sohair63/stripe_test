module Respondable
  extend ActiveSupport::Concern

  def render_okay(json_content = {})
    render status: :ok, json: json_content
  end

  def render_unprocessable_entity(errors = [])
    render status: :unprocessable_entity, json: errors
  end
end
