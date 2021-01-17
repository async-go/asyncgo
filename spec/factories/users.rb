# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    trait :team do
      team
    end
  end
end
