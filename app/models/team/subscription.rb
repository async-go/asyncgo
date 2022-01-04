# frozen_string_literal: true

class Team
  class Subscription < ApplicationRecord
    # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
    validates :team_id, uniqueness: true, presence: true
    # rubocop:enable Rails/RedundantPresenceValidationOnBelongsTo

    belongs_to :team
  end
end
