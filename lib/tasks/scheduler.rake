# frozen_string_literal: true

desc 'Sends a digest email containing active notifications to all users'
task send_digest_emails: :environment do
  puts 'Starting'
  User.find_each do |user|
    puts "Sending notifications for #{user.email}"
    DigestMailer.with(user: user).digest_email.deliver_now
  end
end

desc 'Creates a notification for topics with <1 day remaining'
task create_notification_due: :environment do
  puts 'Starting'
  Topic.where(status: :active).find_each do |topic|
    if !topic.due_date.nil? && Time.zone.today + 1 > topic.due_date && Time.zone.today <= topic.due_date
      puts "Creating due notifications for #{topic.title} (due #{topic.due_date})"
      topic.subscribed_users.find_each do |user|
        topic.notifications.create(actor: topic.user, user_id: user, action: :expiring)
      end
    end
  end
end
