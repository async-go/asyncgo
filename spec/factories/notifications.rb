# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user
    action { :updated }

    association :actor, factory: :user
    association :target, factory: :topic
  end
end
