# frozen_string_literal: true

class Team < ApplicationRecord
  INVALID_CHARS = ':\/'

  validates :name, presence: { allow_blank: false, allow_empty: false },
                   format: { without: Regexp.new("[#{Regexp.escape(INVALID_CHARS)}]") }
  validates :message, presence: { allow_blank: false, allow_empty: false, allow_nil: true }

  has_one :subscription, class_name: 'Team::Subscription', dependent: :destroy

  has_many :users, dependent: :nullify
  has_many :topics, dependent: :destroy
end
