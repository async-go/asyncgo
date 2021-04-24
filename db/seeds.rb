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
  user: alice, team: asyncgo, title: '☑️ Daily standup', due_date: Time.zone.today,
  description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
  label_list: 'standup'
)

# Topic Votes
Vote.create!(user: bob, votable: topic, emoji: 'thumbsup')

# Comment
comment = Comment.create!(
  user: bob, topic: topic, body: 'No update from me today', body_html: 'No update from me today'
)

# Comment Votes
Vote.create!(user: alice, votable: comment, emoji: 'thumbsdown')

# Subscriptions
Subscription.create!(topic: topic, user: matija)
Subscription.create!(topic: topic, user: jason)
Subscription.create!(topic: topic, user: bob)
Subscription.create!(topic: topic, user: alice)
Subscription.create!(topic: topic, user: carol)
Subscription.create!(topic: topic, user: david)

# Notifications
Notification.create!(user: jason, actor: bob, action: :created, target: comment)
Notification.create!(user: jason, actor: alice, action: :updated, target: topic)
Notification.create!(user: matija, actor: bob, action: :updated, target: topic)
Notification.create!(user: matija, actor: alice, action: :updated, target: topic)

# Topics
topic = Topic.create!(user: bob, title: '📰 Lets discuss our next marketing campaign',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      team: asyncgo, due_date: Time.zone.today + 5, label_list: 'marketing')
Subscription.create!(topic: topic, user: jason)
Subscription.create!(topic: topic, user: bob)

topic = Topic.create!(user: bob, title: '📈 Competitive analysis vs. our top competitor',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'We are the best', outcome_html: '<p>We are the best</p>',
                      team: asyncgo, due_date: Time.zone.today - 2, pinned: true,
                      label_list: 'important competitive-analysis')
Subscription.create!(topic: topic, user: carol)
Subscription.create!(topic: topic, user: david)

topic = Topic.create!(user: bob, title: '🏗️  Discuss next big feature',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      team: asyncgo, due_date: Time.zone.today + 4, label_list: 'product')
Subscription.create!(topic: topic, user: matija)
Subscription.create!(topic: topic, user: jason)
Subscription.create!(topic: topic, user: bob)

topic = Topic.create!(user: alice, title: '👶 Plan baby shower for Alice',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'Action items', outcome_html: '<p>Action items</p>',
                      label_list: 'fun', team: asyncgo, due_date: Time.zone.today,
                      status: :resolved)
Subscription.create!(topic: topic, user: bob)
Subscription.create!(topic: topic, user: alice)
Subscription.create!(topic: topic, user: carol)

topic = Topic.create!(user: alice, title: '🎉 Agenda for 100 customers party ',
                      description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
                      outcome: 'All good so far', outcome_html: '<p>All good so far</p>',
                      label_list: 'fun', team: asyncgo, due_date: nil)
Subscription.create!(topic: topic, user: carol)
Subscription.create!(topic: topic, user: david)
