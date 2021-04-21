# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: { allow_blank: false, allow_empty: false }
  validates :message, presence: { allow_blank: false, allow_empty: false, allow_nil: true }

  has_one :subscription, class_name: 'Team::Subscription', dependent: :destroy

  has_many :users, dependent: :nullify
  has_many :topics, dependent: :destroy
end
