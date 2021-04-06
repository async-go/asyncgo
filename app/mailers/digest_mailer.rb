# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper Users::NotificationsHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = params[:notifications].uniq do |notification|
      notification.values_at(:target_id, :actor_id, :user_id, :action)
    end

    @user = params[:user]
    @recentlyresolved = params[:recentlyresolved]

    mail(to: @user.email, subject: 'Your AsyncGo Digest', notifications: @notifications, recentlyresolved: @recentlyresolved)
  end
end
