# frozen_string_literal: true

require 'factory_bot'

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    team = Team.create!(id: 1001, name: 'sample team')

    user = User.new(id: 1001, email: 'digestmailer-user@preview.com', name: 'Bob Test', team: team)
    user.preferences = User::Preferences.new(user: user)
    user.save!

    actor = User.new(id: 2001, email: 'digestmailer-actor@preview.com', name: 'Actor Sample', team: team)
    actor.preferences = User::Preferences.new(user: actor)
    actor.save!

    topic = Topic.create!(id: 1001, title: 'Test Topic', team: team, user: user, status: :resolved,
                         description: 'Hello', description_html: '<p>Hello</p>')

    Notification.create!(id: 1001, user: user, actor: actor, target: topic, action: 'created')
    Topic.create!(id: 2001, title: 'Due Topic', team: team, user: user, status: :active, due_date: Date.today,
                  description: 'Hello', description_html: '<p>Hello</p>')

    DigestMailer.with(user: user).digest_email.message.tap do
      Team.find(1001).destroy
      User.find(1001).destroy
      User.find(2001).destroy
    end
  end
end
