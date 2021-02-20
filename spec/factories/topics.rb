# frozen_string_literal: true

FactoryBot.define do
  factory :topic, aliases: %i[votable target] do
    title { Faker::Marketing.buzzwords }
    description { Faker::Lorem.paragraph }
    description_html { CommonMarker.render_html(description) }
    outcome_html { CommonMarker.render_html(outcome.to_s).presence }

    team
    user { association :user, team: team }

    subscribed_users { [user] }
  end
end
