# frozen_string_literal: true

require 'factory_bot'

# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def digest_email
    seed_data

    DigestMailer.with(user: User.find(1001)).digest_email.message.tap do
      Team.find(1001).destroy
      User.find(1001).destroy
      User.find(2001).destroy
    end
  end

  private

  def seed_data
    team = Team.create!(id: 1001, name: 'sample team')

    user = User.new(id: 1001, email: 'digestmailer-user@preview.com', name: 'Bob Test', team:)
    user.update!(preferences: User::Preferences.new(user:))

    actor = User.new(id: 2001, email: 'digestmailer-actor@preview.com', name: 'Actor Sample', team:)
    actor.update!(preferences: User::Preferences.new(user: actor))

    topic = Topic.create!(id: 1001, title: 'Test Topic', team:, user:, status: :resolved,
                          description: 'Hello', description_html: '<p>Hello</p>')

    Notification.create!(id: 1001, user:, actor:, target: topic, action: 'created')
    Topic.create!(id: 2001, title: 'Due Topic', team:, user:, status: :active, due_date: Time.zone.today,
                  description: 'Hello', description_html: '<p>Hello</p>')
  end
end
