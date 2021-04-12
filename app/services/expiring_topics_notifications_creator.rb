# frozen_string_literal: true

class ExpiringTopicsNotificationsCreator < ApplicationService
  def call
    Rails.logger.info 'Starting expiring topics notifications creation'
    expiring_topics.find_each do |topic|
      Rails.logger.info "Creating expiring notifications for Topic #{topic.id}"
      topic.subscribed_users.find_each do |user|
        Rails.logger.info "Creating expiring notification for #{user.email}"
        topic.notifications.create!(actor_id: topic.user_id, user: user, action: :expiring)
      end
    end
  end

  private

  def expiring_topics
    Topic.where(status: :active, due_date: Time.zone.today..Time.zone.tomorrow)
  end
end
