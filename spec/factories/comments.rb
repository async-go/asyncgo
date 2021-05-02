# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }

    association :user, :team
    topic { association :topic, team: user.team }
  end
end
