# frozen_string_literal: true

class TeamSubscription < ApplicationRecord
  validates :team_id, uniqueness: true, presence: true

  belongs_to :team
end
