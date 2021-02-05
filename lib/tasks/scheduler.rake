# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts 'Starting'
  User.find_each do |user|

    puts "Sending notifications for #{user.email}"
    DigestMailer.with(user: user).digest_email.deliver_later
  end
end
