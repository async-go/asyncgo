# frozen_string_literal: true

module FastSpring
  BASE_URL = 'https://api.fastspring.com'

  def self.generate_account_management_link(email)
    account_id = find_account(email)

    connection = Faraday.new(url: BASE_URL)
    connection.basic_auth(ENV['FAST_SPRING_USERNAME'], ENV['FAST_SPRING_PASSWORD'])
    response = connection.get("/accounts/#{account_id}/authenticate")
    account_management_url = JSON.parse(response.body)['accounts'].first['url']
    "#{account_management_url}#/subscriptions"
  end

  private_class_method def self.find_account(email)
    connection = Faraday.new(url: BASE_URL)
    connection.basic_auth(ENV['FAST_SPRING_USERNAME'], ENV['FAST_SPRING_PASSWORD'])
    response = connection.get('/accounts', { email: email })
    JSON.parse(response.body)['accounts'].first['id']
  end
end
