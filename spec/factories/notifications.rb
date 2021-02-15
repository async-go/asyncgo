# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :user, :team
    action { :updated }

    actor { association :actor, team: user.team }
    target { association :target, team: user.team }
  end
end
