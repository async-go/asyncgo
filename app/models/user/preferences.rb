# frozen_string_literal: true

class User
  class Preferences < ApplicationRecord
    validates :user_id, uniqueness: true, presence: true

    belongs_to :user
  end
end
