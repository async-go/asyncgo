# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    title { Faker::Marketing.buzzwords }
    description { Faker::Lorem.paragraph }
    description_html { CommonMarker.render_html(description) }
    user
    team
  end
end
