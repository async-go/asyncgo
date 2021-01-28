# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    user = User.new(email: 'test@example.com')
    user.team = Team.new(name: 'example team')
    notifications = Notification.new

    DigestMailer.with(user: user, notifications: notifications).digest_email
  end
end
