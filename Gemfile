# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Core
gem 'bootsnap', '>= 1.4.4', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'puma', '~> 5.0' # Use Puma as the app server
gem 'pundit', '~> 2.1.0' # Authorization via OO and plain Ruby classes
gem 'rails', '~> 6.1.1'
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 5.0' # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# Other
gem 'commonmarker', '0.21.0' # GitHub Flavored Markdown renderer
gem 'hamlit', '~> 2.14.1' # Templating language
gem 'omniauth-google-oauth2', '~> 0.8.0'
gem 'omniauth-rails_csrf_protection', '~> 1.0.0'

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
  gem 'rubocop', '~> 1.8.0', require: false
  gem 'rubocop-performance', '~> 1.9.0', require: false
  gem 'rubocop-rails', '~> 2.9.0', require: false
  gem 'rubocop-rspec', '~> 2.1.0', require: false
  ## Haml linter
  gem 'haml_lint', '~> 0.37.0', require: false
  # Other
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugger console by calling 'byebug' anywhere in code
  gem 'dotenv-rails', '~> 2.7.6'
  gem 'rspec-rails', '~> 4.0.1' # rspec testing
  gem 'spring', '~> 2.1.1' # Speeds up development by keeping application running in the background - https://github.com/rails/spring
  gem 'sqlite3', '~> 1.4' # Use sqlite3 as the database for Active Record
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
  gem 'capybara', '>= 3.26' # Support for Capybara system testing
  gem 'factory_bot_rails', '~> 6.1.0' # Factories for generating AR objects in specs
  gem 'faker', '~> 2.15.1' # Fake data for use in specs
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 4.5.0' # Additional rspec matchers
  gem 'webdrivers' # Easy installation and use of web drivers for system tests
end

group :production do
  gem 'pg', '~> 1.2.3' # Use pg as the database for Active Record
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'omniauth-github', '~> 2.0'
