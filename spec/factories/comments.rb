# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    body_html { CommonMarker.render_html(body) }

    association :user, :team
    topic { association :topic, team: user.team }
  end
end
