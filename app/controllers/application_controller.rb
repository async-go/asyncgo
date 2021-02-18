# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized(_exception)
    flash[:warning] = 'You are not authorized.'

    redirect_back fallback_location: root_path
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id]).tap do |user|
          session[:user_id] = nil unless user
        end
      end
    end
  end
  helper_method :current_user

  def unique_unread_notifications
    @unique_unread_notifications ||= begin
      Notification
        .includes(:actor, :target, :user)
        .where(user: current_user, read_at: nil)
        .group(:target_id, :target_class, :actor_id, :user_id, :action)
    end
  end
  helper_method :unique_unread_notifications
end
