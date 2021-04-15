# frozen_string_literal: true

class OmniauthCallbacksController < ApplicationController
  def google_oauth2
    response = request.env['omniauth.auth'].info
    handle_auth(response['email'], response['name'])
  end

  def github
    response = request.env['omniauth.auth'].info
    handle_auth(response['email'], response['name'])
  end

  def microsoft_graph
    response = request.env['omniauth.auth'].info
    handle_auth(response['email'], "#{response['first_name']} #{response['last_name']}")
  end

  def slack
    response = request.env['omniauth.strategy'].access_token
    access_token = OmniAuth::Slack.build_access_token(
      ENV['SLACK_CLIENT_ID'],
      ENV['SLACK_CLIENT_SECRET'],
      response.authed_user.token
    )
    response = access_token.get('/api/users.identity').parsed['user']
    handle_auth(response['email'], response['name'])
  end

  private

  def handle_auth(email, name)
    user = User.from_omniauth(email, name)

    if user.persisted?
      flash[:success] = 'User was successfully authenticated.'
      session[:user_id] = user.id
    else
      flash[:danger] = 'Could not authenticate user.'
    end

    redirect_to root_path
  end
end
