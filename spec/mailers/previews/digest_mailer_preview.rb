# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    team = Team.new(name: 'sample team')
    user = User.new(id: 1, email: 'test@example.com', name: 'Bob Test', team: team)
    actor = User.new(email: 'actor@example.com', name: 'John Doe', team: team)
    topic = Topic.new(title: 'example topic', team: team, user: actor)
    notifications = [Notification.new(id: 1, target: topic, user: user, actor: actor, action: :created)]

    DigestMailer.with(user: user, notifications: notifications).digest_email
  end
end
