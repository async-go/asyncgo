# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized(_exception)
    flash[:warning] = 'You are not authorized.'

    redirect_back fallback_location: root_path
  end

  def current_user
    return unless session[:user_id]

    user = User.find_by(id: session[:user_id])
    session[:user_id] = nil unless user

    @current_user ||= user
  end
  helper_method :current_user
end
