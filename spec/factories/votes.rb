# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    emoji { Emoji.all.sample.aliases.sample }

    user
    association :votable, factory: :topic
  end
end
