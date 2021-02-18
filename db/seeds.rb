# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Team
asyncgo = Team.create!(name: 'AsyncGo')

# Users
jason = User.new(name: 'Jason Yavorska', email: 'jason@asyncgo.com', team: asyncgo).tap do |user_jason|
  user_jason.preference = user_jason.build_preference
  user_jason.save!
end

matija = User.new(name: 'Matija Cupic', email: 'matija@asyncgo.com', team: asyncgo).tap do |user_matija|
  user_matija.preference = user_matija.build_preference
  user_matija.save!
end

bob = User.new(name: 'Bob Tester', email: 'testdata-bob@asyncgo.com', team: asyncgo).tap do |user_bob|
  user_bob.preference = user_bob.build_preference
  user_bob.save!
end

User.new(name: 'Larry Sample', email: 'testdata-larry@asyncgo.com').tap do |user_larry|
  user_larry.preference = user_larry.build_preference
  user_larry.save!
end

# Topic
topic = Topic.create!(
  user: jason, team: asyncgo, title: 'Daily standup', due_date: Time.zone.today,
  description: '- Hello', description_html: '<ul><li>Hello</li></ul>'
)

# Topic Votes
Vote.create!(user: matija, votable: topic, emoji: 'thumbsup')

# Comment
comment = Comment.create!(
  user: matija, topic: topic, body: 'No update from me today', body_html: 'No update from me today'
)

# Comment Votes
Vote.create!(user: jason, votable: comment, emoji: 'thumbsdown')

# Subscriptions
Subscription.create!(topic: topic, user: matija)

# Notifications
Notification.create!(user: jason, actor: matija, action: :created, target: comment)
Notification.create!(user: jason, actor: matija, action: :updated, target: topic)
Notification.create!(user: matija, actor: jason, action: :updated, target: topic)

# Topics
Topic.create!(user: bob, title: 'Lets discuss our next marketing campaign',
              description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
              team: asyncgo, due_date: Time.zone.today + 5)
Topic.create!(user: bob, title: 'Competitive analysis vs. our top competitor',
              description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
              outcome: 'We are the best', outcome_html: '<p>We are the best</p>',
              team: asyncgo, due_date: Time.zone.today - 2)
Topic.create!(user: bob, title: 'Discuss possible next big features',
              description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
              team: asyncgo, due_date: Time.zone.today + 4)
Topic.create!(user: bob, title: 'Feedback on our latest demo',
              description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
              outcome: 'Action items', outcome_html: '<p>Action items</p>',
              team: asyncgo, due_date: Time.zone.today)
Topic.create!(user: bob, title: 'Review general customer feedback so far',
              description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
              outcome: 'All good so far', outcome_html: '<p>All good so far</p>',
              team: asyncgo, due_date: nil)
