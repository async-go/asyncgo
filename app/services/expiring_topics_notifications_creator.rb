# frozen_string_literal: true

class ExpiringTopicsNotificationsCreator < ApplicationService
  def call
    puts 'Starting create_notification_due'
    Topic.where(
      status: :active, due_date: Time.zone.today..Time.zone.tomorrow
    ).find_each do |topic|
      puts "Creating due notifications for #{topic.id} (due #{topic.due_date})"
      topic.subscribed_users.find_each do |user|
        puts "Creating notification for #{user.email}"
        topic.notifications.create!(actor_id: topic.user_id, user: user, action: :expiring)
      end
      puts '----'
    end
  end
end
