# frozen_string_literal: true

class User
  class Preferences < ApplicationRecord
    # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
    validates :user_id, uniqueness: true, presence: true
    # rubocop:enable Rails/RedundantPresenceValidationOnBelongsTo

    belongs_to :user
  end
end
