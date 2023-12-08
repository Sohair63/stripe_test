# frozen_string_literal: true

# Parent class for all models. Entry point for all extensions and
# customizations.
#
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
