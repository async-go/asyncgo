# frozen_string_literal: true

class DigestEmailSender < ApplicationService
  def call
    Rails.logger.info 'Starting digest creation'
    User.includes(:preference).find_each do |user|
      next unless user.preference.digest_enabled?

      unread_notifications = unread_notifications_for(user)
      recently_resolved_topics = recently_resolved_topics_for(user)
      next if unread_notifications.empty? && recently_resolved_topics.empty?

      Rails.logger.info "Sending digest to #{user.email}"
      send_digest(user, unread_notifications, recently_resolved_topics)
    end
  end

  private

  def unread_notifications_for(user)
    user.notifications.where(read_at: nil)
  end

  def recently_resolved_topics_for(user)
    user.team.topics.where(
      updated_at: (Time.zone.now - 24.hours)..Time.zone.now, status: :closed
    )
  end

  def send_digest(user, unread_notifications, recently_resolved_topics)
    DigestMailer.with(
      user: user, notifications: unread_notifications,
      recently_resolved_topics: recently_resolved_topics
    ).digest_email.deliver_later
  end
end
