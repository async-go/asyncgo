# frozen_string_literal: true

module FastSpring
  BASE_URL = 'https://api.fastspring.com'

  def self.generate_account_management_link(email)
    account_id = find_account(email)

    response = send_request("/accounts/#{account_id}/authenticate")
    account_management_url = JSON.parse(response.body)['accounts'].first['url']
    "#{account_management_url}#/subscriptions"
  end

  private_class_method def self.find_account(email)
    response = send_request('/accounts', { email: email })
    JSON.parse(response.body)['accounts'].first['id']
  end

  private_class_method def self.send_request(endpoint, params = nil)
    Faraday.new(url: BASE_URL) do |connection|
      connection.basic_auth(ENV['FAST_SPRING_USERNAME'], ENV['FAST_SPRING_PASSWORD'])
    end.get(endpoint, params)
  end
end
