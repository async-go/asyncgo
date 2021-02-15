# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    emoji { Emoji.all.sample.aliases.sample }

    association :user, :team
    votable { association :votable, team: user.team }
  end
end
