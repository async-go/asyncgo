# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Company.name.gsub(/[^0-9A-Za-z]/, '') }
  end
end
