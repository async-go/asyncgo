# frozen_string_literal: true

class Team
  class Subscription < ApplicationRecord
    validates :team_id, uniqueness: true, presence: true

    belongs_to :team
  end
end
