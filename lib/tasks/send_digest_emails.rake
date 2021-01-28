# frozen_string_literal: true

namespace :app do
  desc 'Sends a digest email containing active notifications to all users'
  task send_digest_emails: :environment do
    puts User.all.count
    User.all.each do |user|
      user.send_digest_email(user.notifications) if user.notifications.count.positive?
    end
  end
end
