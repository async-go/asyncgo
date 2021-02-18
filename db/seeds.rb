# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Team
asyncgo = Team.create(name: 'AsyncGo')

# Users
jason = User.create(id: 0, name: 'Jason Yavorska', email: 'jason@asyncgo.com', team: asyncgo)
matija = User.create(id: 1, name: 'Matija Cupic', email: 'matija@asyncgo.com', team: asyncgo)
bob = User.create(id: 2, name: 'Bob Tester', email: 'testdata-bob@asyncgo.com', team: asyncgo)
alice = User.create(id: 3, name: 'Alice Sample', email: 'testdata-alice@asyncgo.com', team: asyncgo)

# Topic
topic = Topic.create(
  user: bob, team: asyncgo, title: 'Daily standup', due_date: Time.zone.today,
  description: '- Hello', description_html: '<ul><li>Hello</li></ul>'
)

# Topic Votes
#Vote.create(user: matija, votable: topic, emoji: 'thumbsup')

# Comment
comment = Comment.create(
  user: alice, topic: topic, body: 'No update from me today', body_html: 'No update from me today'
)

# Comment Votes
#Vote.create(user: alice, votable: comment, emoji: 'thumbsdown')

# Subscriptions
Subscription.create(topic: topic, user: matija)
Subscription.create(topic: topic, user: jason)

# Notifications
Notification.create(user: jason, actor: bob, action: :created, target: comment)
Notification.create(user: jason, actor: alice, action: :updated, target: topic)
Notification.create(user: matija, actor: bob, action: :created, target: comment)
Notification.create(user: matija, actor: alice, action: :updated, target: topic)


# Topics
Topic.create(user: bob, title: 'Lets discuss our next marketing campaign',
             description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
             due_date: Time.zone.today + 5)
Topic.create(user: alice, title: 'Competitive analysis vs. our top competitor',
             description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
             outcome: 'We are the best', outcome_html: '<p>We are the best</p>',
             due_date: Time.zone.today - 2)
Topic.create(user: bob, title: 'Discuss possible next big features',
             description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
             due_date: Time.zone.today + 4)
Topic.create(user: alice, title: 'Feedback on our latest demo',
             description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
             outcome: 'Action items', outcome_html: '<p>Action items</p>',
             due_date: Time.zone.today)
Topic.create(user: alice, title: 'Review general customer feedback so far',
             description: '- Hello', description_html: '<ul><li>Hello</li></ul>',
             outcome: 'All good so far', outcome_html: '<p>All good so far</p>',
             due_date: nil)
