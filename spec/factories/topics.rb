# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    title { Faker::Marketing.buzzwords }
    user
    team
  end
end
