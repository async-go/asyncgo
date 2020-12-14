# frozen_string_literal: true

class OmniauthCallbacksController < ApplicationController
  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.persisted?
      flash[:success] = 'User was successfully authenticated.'
      session[:user_id] = user.id
    else
      flash[:danger] = 'Could not authenticate user.'
    end

    redirect_to root_path
  end
end
