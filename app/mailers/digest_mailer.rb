# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper Users::NotificationsHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @notifications = params[:notifications].uniq do |notification|
      notification.values_at(:target_id, :actor_id, :user_id, :action)
    end

    @user = params[:user]
    @recently_resolved_topics = params[:recently_resolved_topics]

    mail(
      to: @user.email, subject: 'Your AsyncGo Digest',
      notifications: @notifications,
      recently_resolved_topics: @recently_resolved_topics
    )
  end
end
