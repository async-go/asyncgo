# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts "Starting"
  User.all.each do |user|
    puts "Processing for #{user.email}"
    next unless user.notifications.exists?
    puts "  Sending #{user.notifications.count} notifications for #{user.email}"
    DigestMailer.with(user: user).digest_email.deliver_later
  end
end
