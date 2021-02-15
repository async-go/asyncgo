# frozen_string_literal: true

class UserPreference < ApplicationRecord
  validates :user_id, uniqueness: true, presence: true

  belongs_to :user
end
