# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def current_user
    return unless session[:user_id]

    user = User.find_by(id: session[:user_id])
    session[:user_id] = nil unless user

    @current_user ||= user
  end
  helper_method :current_user
end
