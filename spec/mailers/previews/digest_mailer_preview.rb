# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    team = Team.new(id: 1, name: 'sample team')
    user = User.new(id: 1, email: 'test@example.com', name: 'Bob Test', team: team)
    actor = User.new(id: 2, email: 'actor@example.com', name: 'Actor Sample', team: team)
    topic = Topic.new(id: 1, title: 'Test Topic', team: team, user: user, status: :closed)
    notifications = [Notification.new(id: 1, user: user, actor: actor, target: topic, action: 'created')]

    DigestMailer.with(
      user: user, recently_resolved_topics: [topic], notifications: notifications
    ).digest_email
  end
end
