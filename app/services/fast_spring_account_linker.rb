# frozen_string_literal: true

class FastSpringAccountLinker < ApplicationService
  BASE_URL = 'https://api.fastspring.com'

  def initialize(email)
    super()

    @email = email
  end

  def call
    response = send_request("/accounts/#{account_id}/authenticate")
    account_management_url = JSON.parse(response.body)['accounts'].first['url']
    "#{account_management_url}#/subscriptions"
  end

  private

  def account_id
    response = send_request('/accounts', { email: @email })
    JSON.parse(response.body)['accounts'].first['id']
  end

  def send_request(endpoint, params = nil)
    Faraday.new(url: BASE_URL) do |connection|
      connection.basic_auth(username, password)
    end.get(endpoint, params)
  end

  def username
    @username ||= Rails.application.config.x.fastspring.username
  end

  def password
    @password ||= Rails.application.config.x.fastspring.password
  end
end
