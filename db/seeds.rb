# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

jason = User.create({ id: 0, name: 'Jason Yavorska', email: 'jason@asyncgo.com' })
matija = User.create({ id: 1, name: 'Matija Cupic', email: 'matija@asyncgo.com' })
bob = User.create({ id: 2, name: 'Bob Tester', email: 'testdata-bob@asyncgo.com' })
larry = User.create({ id: 3, name: 'Larry Sample', email: 'testdata-larry@asyncgo.com' })

asyncgo = Team.create({ id: 0, name: 'AsyncGo', users: [jason, matija] })

# rubocop:disable Metrics/MethodLength
def create_topic(options = {})
  description_html = CommonMarker.render_html(options.fetch(:description), :DEFAULT, %i[tasklist tagfilter autolink])
  topic = Topic.create({ id: options.fetch(:id),
                         user_id: options.fetch(:user).id,
                         subscribed_users: [options.fetch(:user)],
                         team_id: options.fetch(:team).id,
                         title: options.fetch(:title),
                         description: options.fetch(:description),
                         description_html: description_html,
                         due_date: options.fetch(:due_date) })
  options.fetch(:team).topics << topic
  topic
end
# rubocop:enable Metrics/MethodLength

topic = create_topic({  id: 0,
                        user: bob,
                        team: asyncgo,
                        title: 'Daily standup',
                        description: '- Hello',
                        due_date: Time.zone.today })

comment = Comment.create({ id: 0,
                           user: larry,
                           topic: topic,
                           body: 'No update from me today',
                           body_html: 'No update from me today' })

topic.subscribed_users << jason
topic.subscribed_users << matija

Notification.create({ id: 0,
                      user: jason,
                      actor: larry,
                      action: :created,
                      target: comment })

Notification.create({ id: 1,
                      user: jason,
                      actor: larry,
                      action: :created,
                      target: topic })

Notification.create({ id: 2,
                      user: matija,
                      actor: larry,
                      action: :created,
                      target: comment })

Notification.create({ id: 3,
                      user: matija,
                      actor: larry,
                      action: :created,
                      target: topic })

create_topic({ id: 1,
               user: bob,
               team: asyncgo,
               title: 'Lets discuss our next marketing campaign',
               description: '- Hello',
               due_date: Time.zone.today + 5 })

create_topic({ id: 2,
               user: larry,
               team: asyncgo,
               title: 'Competitive analysis vs. our top competitor',
               description: '- Hello',
               due_date: Time.zone.today - 2 })

create_topic({ id: 3,
               user: bob,
               team: asyncgo,
               title: 'Discuss possible next big features',
               description: '- Hello',
               due_date: Time.zone.today + 4 })

create_topic({ id: 4,
               user: larry,
               team: asyncgo,
               title: 'Feedback on our latest demo',
               description: '- Hello',
               due_date: Time.zone.today })

create_topic({ id: 5,
               user: bob,
               team: asyncgo,
               title: 'Review general customer feedback so far',
               description: '- Hello',
               due_date: nil })
