# frozen_string_literal: true

class DigestEmailSender < ApplicationService
  def call
    Rails.logger.info 'Starting digest creation'
    User.includes(:preferences).find_each do |user|
      next unless user.preferences.digest_enabled?

      unread_notifications = unread_notifications_for(user)
      recently_resolved_topics = recently_resolved_topics_for(user)
      next if unread_notifications.empty? && recently_resolved_topics.empty?

      Rails.logger.info "Sending digest to #{user.email}"
      send_digest(user)
    end
  end

  private

  def unread_notifications_for(user)
    user.notifications.where(read_at: nil)
  end

  def recently_resolved_topics_for(user)
    user.team.topics.where(
      updated_at: 24.hours.ago..Time.zone.now, status: :closed
    )
  end

  def send_digest(user)
    DigestMailer.with(user: user).digest_email.deliver_later
  end
end
