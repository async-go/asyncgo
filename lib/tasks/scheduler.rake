# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts 'Starting'
  User.find_each do |user|
    notifications = user.notifications.where(read_at: nil)

    next if notifications.empty?

    puts "Sending #{notifications.count} notifications for #{user.email}"
    DigestMailer.with(user: user, notifications: notifications).digest_email.deliver_now
  end
end
