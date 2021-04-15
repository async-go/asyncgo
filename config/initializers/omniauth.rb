# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
           {
             prompt: 'select_account'
           }
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'],
           {
             scope: 'user:email'
           }
  provider :microsoft_graph, ENV['AZURE_APPLICATION_CLIENT_ID'],
           ENV['AZURE_APPLICATION_CLIENT_SECRET'],
           {
             scope: 'User.Read'
           }
  provider :slack, ENV['SLACK_CLIENT_ID'], ENV['SLACK_CLIENT_SECRET'],
           {
             user_scope: 'identity.basic,identity.email'
           }
end
