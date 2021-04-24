# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  helper Users::NotificationsHelper
  default from: 'notifications@asyncgo.com'

  def digest_email
    @user = params[:user]
    @unread_notifications = unread_notifications
    @recently_resolved_topics = recently_resolved_topics

    mail(to: @user.email, subject: 'Your AsyncGo Digest')
  end

  private

  def user
    params[:user]
  end

  def unread_notifications
    user.notifications.where(read_at: nil).uniq do |notification|
      notification.values_at(:target_id, :actor_id, :user_id, :action)
    end
  end

  def recently_resolved_topics
    user.team.topics.where(
      updated_at: (Time.zone.now - 24.hours)..Time.zone.now, status: :resolved
    )
  end
end
