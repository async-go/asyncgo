# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized(_exception)
    flash[:warning] = I18n.t(:you_are_not_authorized)

    redirect_back fallback_location: root_path
  end

  def current_user
    @current_user ||= if session[:user_id]
                        User.find_by(id: session[:user_id]).tap do |user|
                          user ? gon.push(user_id: user.id, team_id: user.team_id) : session.delete(:user_id)
                        end
                      end
  end
  helper_method :current_user

  def unique_unread_notifications
    @unique_unread_notifications ||= Notification.includes(:actor, :user,
                                                           :target).where(id: notification_grouping_subquery)
  end
  helper_method :unique_unread_notifications

  private

  def notification_grouping_subquery
    Notification
      .where(user: current_user, read_at: nil)
      .select('MAX(id)').group(:target_id, :target_type, :actor_id, :user_id, :action)
  end
end
