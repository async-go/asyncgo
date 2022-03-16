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
  user_jason.preferences = user_jason.build_preferences
  user_jason.save!
end

matija = User.new(name: 'Matija Cupic', email: 'matija@asyncgo.com', team: asyncgo).tap do |user_matija|
  user_matija.preferences = user_matija.build_preferences
  user_matija.save!
end

bob = User.new(name: 'Bob Tester', email: 'testdata-bob@asyncgo.com', team: asyncgo).tap do |user_bob|
  user_bob.preferences = user_bob.build_preferences
  user_bob.save!
end

alice = User.new(name: 'Alice Samples', email: 'testdata-alice@asyncgo.com', team: asyncgo).tap do |user_alice|
  user_alice.preferences = user_alice.build_preferences
  user_alice.save!
end

carol = User.new(name: 'Carol Demoer', email: 'testdata-carol@asyncgo.com', team: asyncgo).tap do |user_carol|
  user_carol.preferences = user_carol.build_preferences
  user_carol.save!
end

david = User.new(name: 'David Samples', email: 'testdata-david@asyncgo.com', team: asyncgo).tap do |user_david|
  user_david.preferences = user_david.build_preferences
  user_david.save!
end

# Topic
topic = Topic.create!(
  user: alice, team: asyncgo, title: '☑️ Release retrospective', due_date: Time.zone.today,
  description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
  label_list: 'standup'
)

# Topic Votes
Vote.create!(user: bob, votable: topic, emoji: 'thumbsup')

# Comment
comment = Comment.create!(
  user: bob, topic:, body: 'I thought things went really well last time.',
  body_html: 'I thought things went really well last time.'
)

# Comment Votes
Vote.create!(user: alice, votable: comment, emoji: 'thumbsdown')

# Subscriptions
Subscription.create!(topic:, user: matija)
Subscription.create!(topic:, user: jason)
Subscription.create!(topic:, user: bob)
Subscription.create!(topic:, user: alice)
Subscription.create!(topic:, user: carol)
Subscription.create!(topic:, user: david)

# Notifications
Notification.create!(user: jason, actor: bob, action: :created, target: comment)
Notification.create!(user: jason, actor: alice, action: :updated, target: topic)
Notification.create!(user: matija, actor: bob, action: :updated, target: topic)
Notification.create!(user: matija, actor: alice, action: :updated, target: topic)

# Topics
topic = Topic.create!(user: bob, title: '📰 It feels like we are having too many meetings',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      team: asyncgo, due_date: Time.zone.today + 5, label_list: 'meetings')
Subscription.create!(topic:, user: jason)
Subscription.create!(topic:, user: bob)

topic = Topic.create!(user: bob, title: '📈 Idea for improving how we track the impact of new features',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'We are the best', outcome_html: '<p>We are the best</p>',
                      team: asyncgo, due_date: Time.zone.today - 2, pinned: true,
                      label_list: 'urgent analytics')
Subscription.create!(topic:, user: carol)
Subscription.create!(topic:, user: david)

topic = Topic.create!(user: bob, title: '🏗️ Is there a better way to run retrospectives?',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      team: asyncgo, due_date: Time.zone.today + 4, label_list: 'retrospectives')
Subscription.create!(topic:, user: matija)
Subscription.create!(topic:, user: jason)
Subscription.create!(topic:, user: bob)

topic = Topic.create!(user: alice, title: '👶 Welcoming new team members with better onboarding',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'Action items', outcome_html: '<p>Action items</p>',
                      label_list: 'onboarding', team: asyncgo, due_date: Time.zone.today,
                      status: :resolved)
Subscription.create!(topic:, user: bob)
Subscription.create!(topic:, user: alice)
Subscription.create!(topic:, user: carol)

topic = Topic.create!(user: alice, title: '🎉 Lets celebrate product launches more!',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'All good so far', outcome_html: '<p>All good so far</p>',
                      label_list: 'fun', team: asyncgo, due_date: nil)
Subscription.create!(topic:, user: carol)
Subscription.create!(topic:, user: david)
