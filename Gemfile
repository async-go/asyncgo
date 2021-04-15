# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

# Core
gem 'bootsnap', '~> 1.7.2', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'gon', '~> 6.4.0' # Pass variables from Rails to JS
gem 'hotwire-rails', '~> 0.1.3' # HTML over the wire. Read more: https://hotwire.dev/
gem 'pg', '~> 1.2.3' # Use pg as the database for Active Record
gem 'puma', '~> 5.2.1' # Use Puma as the app server
gem 'pundit', '~> 2.1.0' # Authorization via OO and plain Ruby classes
gem 'rails', '~> 6.1.3'
gem 'redis', '~> 4.2.5' # Use Redis adapter to run Action Cable in production
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'sidekiq', '~> 6.2.0' # ActiveJob backend
gem 'webpacker', '6.0.0.beta.6 ' # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# Other
gem 'acts-as-taggable-on', '~> 7.0.0' # Tags
gem 'blazer', '~> 2.4.2' # Business Intelligence made easy
gem 'commonmarker', '~> 0.21.0' # GitHub Flavored Markdown renderer
gem 'font-awesome-sass', '~> 5.15.1'
gem 'gemoji', '~> 3.0.1' # emoji helpers
gem 'ginjo-omniauth-slack', '~> 2.5', require: 'omniauth-slack'
gem 'hamlit', '~> 2.14.1' # Templating language
gem 'omniauth-github', '~> 2.0.0'
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'omniauth-microsoft_graph', '~> 0.2.1'
gem 'omniauth-rails_csrf_protection', '~> 1.0.0'
gem 'pagy', '~> 3.11.0' # pagination

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Linters
  ## Ruby linter
  gem 'rubocop', '~> 1.10.0', require: false
  gem 'rubocop-performance', '~> 1.9.0', require: false
  gem 'rubocop-rails', '~> 2.9.0', require: false
  gem 'rubocop-rspec', '~> 2.2.0', require: false
  ## Haml linter
  gem 'haml_lint', '~> 0.37.0', require: false
  # Other
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugger console by calling 'byebug' anywhere in code
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'rspec-rails', '~> 4.0.1' # rspec testing
  gem 'spring', '~> 2.1.1' # Speeds up development by keeping application running in the background - https://github.com/rails/spring
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
  gem 'axe-core-rspec', '~> 4.1.0' # rspec accessibility matcher
  gem 'brakeman', '~> 5.0.0'
  gem 'capybara', '>= 3.26' # Support for Capybara system testing
  gem 'factory_bot_rails', '~> 6.1.0' # Factories for generating AR objects in specs
  gem 'faker', '~> 2.16.0' # Fake data for use in specs
  gem 'rspec-retry', '~> 0.6.2' # retry rspec tests
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.5.0' # Additional rspec matchers
  gem 'webdrivers' # Easy installation and use of web drivers for system tests
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
