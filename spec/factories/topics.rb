# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    title { Faker::Marketing.buzzwords }
    description { Faker::Lorem.paragraph }
    user
    team
  end
end
