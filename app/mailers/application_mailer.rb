# frozen_string_literal: true

# Parent class for all mailers. Used for global settings.
#
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
