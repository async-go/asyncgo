# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts 'Starting send_digest_emails'
  Team.find_each do |team|
    team.users.includes(:preference).find_each do |user|
      next unless user.preference.digest_enabled?

      recently_resolved_topics = team.topics.where(
        updated_at: (Time.zone.now - 24.hours)..Time.zone.now, status: :closed
      )
      notifications = user.notifications.where(read_at: nil)
      next if user.notifications.empty? && recently_resolved_topics.empty?

      puts "Sending #{notifications.count} notifications for #{user.email}"
      DigestMailer.with(
        user: user, notifications: notifications,
        recently_resolved_topics: recently_resolved_topics
      ).digest_email.deliver_later
    end
  end
end

desc 'Creates a notification for topics with < 1 day remaining'
task create_expiring_topics_notifications: :environment do
  ExpiringTopicsNotificationsCreator.new.call
end
