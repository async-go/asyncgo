# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: { allow_blank: false }

  enum tier: { free: 0, paid: 1, enterprise: 2, free_forever: 3 }

  has_many :users, dependent: :nullify
  has_many :topics, dependent: :destroy
end
