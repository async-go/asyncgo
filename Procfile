release: bin/rails db:migrate
web: bin/rails server --port ${PORT:-5000} --environment $RAILS_ENV
worker: bundle exec sidekiq --environment $RAILS_ENV
