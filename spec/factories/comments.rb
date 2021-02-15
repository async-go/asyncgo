# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    body_html { CommonMarker.render_html(body) }

    topic
    user { association :user, team: topic.team }
  end
end
