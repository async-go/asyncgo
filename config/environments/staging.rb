# frozen_string_literal: true

# Use production settings
require File.expand_path('production.rb', __dir__)

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'staging.asyncgo.com' }
end
