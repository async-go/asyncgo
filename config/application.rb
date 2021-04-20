# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Asyncgo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'UTC'
    # config.eager_load_paths << Rails.root.join("extras")

    # Add bootstrap scss to sass load path
    config.sass.load_paths << Rails.root.join('node_modules/bootstrap/scss')

    # Sharing configuration
    config.site_description = 'Smarter decisions, more alignment, and outsized
      outcomes: AsyncGo helps your team collaborate better with fewer chat and
      meeting interruptions.'
    config.site_title = 'Sign In to AsyncGo'
    config.site_image = 'social.png'
    config.release_date = DateTime.new(2021,3,22)
    config.release_name = '1.1'
    config.release_link = 'https://asyncgo.com/blog/release/2020/03/22/asyncgo-1.1.html'
  end
end
