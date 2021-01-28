# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    user = User.new(id: 0, email: 'test@example.com', name: 'Bob Test')
    topic = Topic.new(title: 'example topic')
    user.team = Team.new(name: 'example team')
    notifications = Notification.new(id: 0, target: topic, user: user, actor: user, action: :updated)

    DigestMailer.with(user: user, notifications: [notifications]).digest_email
  end
end
