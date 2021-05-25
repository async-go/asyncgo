# frozen_string_literal: true

Rails.application.config.x.slack.client_id = ENV['SLACK_CLIENT_ID']
Rails.application.config.x.slack.client_secret = ENV['SLACK_CLIENT_SECRET']
Rails.application.config.x.fastspring.crypto_key = ENV['FASTSPRING_CRYPTO_KEY']
Rails.application.config.x.fastspring.store_url = ENV['FASTSPRING_STORE_URL']
Rails.application.config.x.fastspring.username = ENV['FASTSPRING_USERNAME']
Rails.application.config.x.fastspring.password = ENV['FASTSPRING_PASSWORD']
