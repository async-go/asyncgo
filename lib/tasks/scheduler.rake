# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts User.count
  User.each do |user|
    next unless user.notifications.exists?

    user.send_digest_email
  end
end
