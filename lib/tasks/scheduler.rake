# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  DigestEmailSender.new.call
end

desc 'Creates a notification for topics with < 1 day remaining'
task create_expiring_topics_notifications: :environment do
  ExpiringTopicsNotificationsCreator.new.call
end
