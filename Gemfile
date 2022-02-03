# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Core
gem 'bootsnap', '~> 1.10.0', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'faraday', '~> 1.9.0' # http client
gem 'gon', '~> 6.4.0' # Pass variables from Rails to JS
gem 'hotwire-rails', '~> 0.1.3' # HTML over the wire. Read more: https://hotwire.dev/
gem 'pg', '~> 1.3.0' # Use pg as the database for Active Record
gem 'puma', '~> 5.6.0' # Use Puma as the app server
gem 'pundit', '~> 2.1.0' # Authorization via OO and plain Ruby classes
gem 'rails', '~> 7.0.1'
gem 'redis', '~> 4.5.1' # Use Redis adapter to run Action Cable in production
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'sidekiq', '~> 6.4.0' # ActiveJob backend
gem 'webpacker', '6.0.0.rc.6 ' # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# Other
gem 'acts-as-taggable-on', '~> 9.0.0' # Tags
gem 'barnes', '~> 0.0.9' # heroku application metrics
gem 'blazer', '~> 2.5.0' # Business Intelligence made easy
gem 'commonmarker', '~> 0.23.2' # GitHub Flavored Markdown renderer
gem 'font-awesome-sass', '~> 5.15.1'
gem 'gemoji', '~> 3.0.1' # emoji helpers
gem 'ginjo-omniauth-slack', '~> 2.5', require: 'omniauth-slack'
gem 'hamlit', '~> 2.16.0' # Templating language
gem 'net-imap', '~> 0.2.3' # this is required
gem 'net-pop', '~> 0.1.1' # this is required
gem 'net-smtp', '~> 0.3.1' # this is required
gem 'omniauth-github', '~> 2.0.0'
gem 'omniauth-google-oauth2', '~> 1.0.0'
gem 'omniauth-microsoft_graph', '~> 1.0.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0.0'
gem 'pagy', '~> 5.9.0' # pagination

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Linters
  ## Ruby linter
  gem 'rubocop', '~> 1.25.0', require: false
  gem 'rubocop-performance', '~> 1.13.1', require: false
  gem 'rubocop-rails', '~> 2.13.0', require: false
  gem 'rubocop-rspec', '~> 2.8.0', require: false
  ## Haml linter
  gem 'haml_lint', '~> 0.37.0', require: false
  # Other
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugger console by calling 'byebug' anywhere in code
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'rspec-rails', '~> 5.0.1' # rspec testing
  gem 'spring', '~> 4.0.0' # Speeds up development by keeping application running in the background - https://github.com/rails/spring
end

group :development do
  # Other
  gem 'listen', '~> 3.3' # Listen for filestystem file changes
  gem 'web-console', '>= 4.1.0' # Interactive console on exception pages and in code by calling 'console'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0', require: false
end

group :test do
  gem 'axe-core-rspec', '~> 4.3.2' # rspec accessibility matcher
  gem 'capybara', '>= 3.26' # Support for Capybara system testing
  gem 'factory_bot_rails', '~> 6.2.0' # Factories for generating AR objects in specs
  gem 'faker', '~> 2.19.0' # Fake data for use in specs
  gem 'rspec-retry', '~> 0.6.2' # retry rspec tests
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.1.0' # Additional rspec matchers
  gem 'webdrivers' # Easy installation and use of web drivers for system tests
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
