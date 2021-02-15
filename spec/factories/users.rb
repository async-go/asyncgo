# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:actor] do
    email { Faker::Internet.email }

    trait :team do
      team
    end

    trait :name do
      name { Faker::Name.name }
    end

    user_preference { UserPreference.new(user: instance) }
  end
end
