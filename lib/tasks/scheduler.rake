# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts 'Starting send_digest_emails'
  Team.find_each do |team|
    recentlyopened = team.topics.where(created_at: (Time.zone.now - 24.hours)..Time.zone.now)
    recentlyresolved = team.topics.where(updated_at: (Time.zone.now - 24.hours)..Time.zone.now, status: :resolved)
    team.users.includes(:preference).find_each do |user|
      next unless user.preference.digest_enabled?

      notifications = user.notifications.where(read_at: nil)
      next if user.notifications.empty? && recentlyopened.empty? && recentlyresolved.empty?

      puts "Sending #{notifications.count} notifications for #{user.email}"
      DigestMailer.with(user: user, notifications: notifications,
                        recentlyopened: recentlyopened,
                        recentlyresolved: recentlyresolved).digest_email.deliver_now
    end
  end
end

desc 'Creates a notification for topics with < 1 day remaining'
task create_notification_due: :environment do
  puts 'Starting create_notification_due'
  Topic.where(status: :active).where(due_date: Time.zone.today..Time.zone.tomorrow).find_each do |topic|
    puts "Creating due notifications for #{topic.id} (due #{topic.due_date})"
    topic.subscribed_users.find_each do |user|
      puts "Creating notification for #{user.email}"
      topic.notifications.create(actor: topic.user, user_id: user, action: :expiring)
    end
    puts '----'
  end
end
