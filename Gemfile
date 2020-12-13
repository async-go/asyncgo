# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Core
gem 'bootsnap', '>= 1.4.4', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'puma', '~> 5.0' # Use Puma as the app server
gem 'rails', '~> 6.1.0'
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'sqlite3', '~> 1.4' # Use sqlite3 as the database for Active Record
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 5.0' # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# Other
gem 'hamlit', '~> 2.13.0' # Templating language

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Linters
  ## Ruby linter
  gem 'rubocop', '~> 1.6.1', require: false
  gem 'rubocop-performance', '~> 1.9.0', require: false
  gem 'rubocop-rails', '~> 2.9.0', require: false
  gem 'rubocop-rspec', '~> 2.0.1', require: false
  ## Haml linter
  gem 'haml_lint', '~> 0.36.0', require: false
  # Other
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugger console by calling 'byebug' anywhere in code
  gem 'rspec-rails', '~> 4.0.1' # rspec testing
  gem 'spring', '~> 2.1.1' # Speeds up development by keeping application running in the background - https://github.com/rails/spring
end

group :development do
  # Other
  gem 'listen', '~> 3.3' # Listen for filestystem file changes
  gem 'web-console', '>= 4.1.0' # Interactive console on exception pages and in code by calling 'console'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
end

group :test do
  gem 'capybara', '>= 3.26' # Support for Capybara system testing
  gem 'factory_bot_rails', '~> 6.1.0' # Factories for generating AR objects in specs
  gem 'faker', '~> 2.15.1' # Fake data for use in specs
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.4.1' # Additional rspec matchers
  gem 'webdrivers' # Easy installation and use of web drivers for system tests
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
